import Foundation

import HomeSceneAPI
import HomeSceneEntity
import HTTPClientAPI
import SharedEntity
import SharingGRDB
import TDFoundation
import TDFoundationExtension

// swiftlint: disable all
public struct HomeSceneWorker: HomeSceneWorkable, Sendable {
  private let httpClient: HTTPClientAPI
  @Dependency(\.defaultDatabase) private var database
  
  public init(httpClient: HTTPClientAPI) {
    self.httpClient = httpClient
  }
  
  public func fetchToDoList(dateString: String) async throws -> [DailyToDoListData] {
    let request = HTTPRequest(
      method: HTTPMethod.get,
      endPoint: URLConstants.ToDo.fetchToDoList,
      queryItems: ["target_date": dateString]
    )
    
    let fetchedToDoList = try await self.httpClient.send(
      input: request,
      serializer: { $0 },
      deserializer: { response in
        try response.validateStatusCode()
        let result: [DailyToDoListData] = try response.decode()
        return result
      }
    )
    
    for dailyToDoListData in fetchedToDoList {
      let (myGroups, myToDos) = self.convertToMyGroupsAndMyToDos(from: dailyToDoListData)
      try await self.writeFetchedToDoListToGRDB(myGroups: myGroups, myToDos: myToDos)
    }
    
    return fetchedToDoList
  }

  public func requestBatchUpdateToServer() async throws {
    let storedItems: [TodoBatchItem] = try await database.read { db in
      try TodoBatchItem.all().fetchAll(db)
    }
    
    guard !storedItems.isEmpty else { return }

    let body = try JSONEncoder().encode(HomeScene.BatchUpdate.TodoBatchRequest(data: storedItems))
    let request = HTTPRequest(
      method: HTTPMethod.post,
      endPoint: URLConstants.ToDo.todoBatch,
      body: body
    )

    try await self.httpClient.send(
      input: request,
      serializer: { $0 },
      deserializer: { response in
        try response.validateStatusCode()
      }
    )

    _ = try await database.write { db in
      try TodoBatchItem.deleteAll(db)
    }
  }
  
  public func loadMonthlyToDoListFromGRDB(dateString: String) async throws -> [DailyToDoListData] {
    let localMonthlyData = try await self.readMonthlyToDoListDataFromGRDB(for: dateString)
    
    return localMonthlyData
  }
}

extension HomeSceneWorker {
  private func convertToMyGroupsAndMyToDos(from dailyData: DailyToDoListData) -> ([MyGroup], [MyToDo]) {
    var myGroups: [MyGroup] = []
    var myToDos: [MyToDo] = []
    
    for group in dailyData.list {
      let myGroup = MyGroup(
        groupId: group.localId.lowercased(),
        date: dailyData.date.toYYYYMMDDStringFromISO8601(),
        name: group.name,
        color: group.color
      )
      myGroups.append(myGroup)
      
      for todo in group.todoList ?? [] {
        let myToDo = MyToDo(
          todoId: todo.localID.lowercased(),
          groupId: group.localId.lowercased(),
          date: dailyData.date.toYYYYMMDDStringFromISO8601(),
          name: todo.name,
          isDone: todo.isDone,
          startDay: todo.startDay,
          endDay: todo.endDay,
          alarmTime: todo.alarmTime,
          isAlarmOn: todo.isAlarmOn,
          isOnlyToday: todo.isOnlyToday,
          repeatToDoId: todo.repeatToDoId
        )
        myToDos.append(myToDo)
      }
    }
    
    return (myGroups, myToDos)
  }
  
  public func writeBatchItemsToGRDB(data: [TodoBatchItem]) async throws {
    try await self.database.write { db in
      for var item in data {
        if try TodoBatchItem.exists(db, key: item.localId.lowercased()) {
          try item.update(db)
        } else {
          try item.insert(db)
        }
      }
    }
  }
  
  public func readBatchItemsFromGRDB() async throws -> [TodoBatchItem] {
    try await self.database.read { db in
      return try TodoBatchItem.fetchAll(db)
    }
  }
  
  public func syncronizeGRDBWithBatchItems() async throws {
    let batchItems = try await self.readBatchItemsFromGRDB()
    
    let updatedToDos = batchItems.compactMap { $0.convertToMyToDo() }
    
    let deletedToDoIds = batchItems.filter { $0.isDelete }.map { $0.localId }
    
    try await self.database.write { db in
      for var todo in updatedToDos {
        try todo.insert(db)
      }
      
      if !deletedToDoIds.isEmpty {
        let placeholders = String(repeating: "?,", count: deletedToDoIds.count).dropLast()
        let sql = "DELETE FROM \(MyToDo.databaseTableName) WHERE todoId IN (\(placeholders))"
        try db.execute(sql: sql, arguments: StatementArguments(deletedToDoIds))
      }
    }
  }
  
  public func syncronizeServerEditGroups() async throws {
    guard let request = try await self.loadPendingEditGroup() else { return }
    
    try await self.httpClient.send(
      input: request,
      serializer: { $0 },
      deserializer: { response in
        try response.validateStatusCode()
      }
    )
    
    try await self.deletePendingEditGroup()
  }
  
  private func loadPendingEditGroup() async throws -> HTTPRequest? {
      try await database.read { db in
          try PendingEditGroup.fetchOne(db)?.toHTTPRequest()
      }
  }
  
  private func deletePendingEditGroup() async throws {
      try await database.write { db in
          try db.execute(sql: "DELETE FROM \(PendingEditGroup.databaseTableName)")
      }
  }
  
  private func writeFetchedToDoListToGRDB(myGroups: [MyGroup], myToDos: [MyToDo]) async throws {
    try await self.database.write { db in
      for var group in myGroups {
        if try !group.exists(db) {
          try group.insert(db)
        }
      }
      
      for var todo in myToDos {
        try todo.insert(db)
      }
    }
  }
  
  private func readMonthlyToDoListDataFromGRDB(for dateString: String) async throws -> [DailyToDoListData] {
    guard let dates = YYYYMMDDGenerator.generateDates(for: dateString) else { return [] }
    return try await self.database.read { db in
      let groups = try MyGroup.fetchAll(db)
      
      var dailyDataDict: [String: [TodoListGroup]] = [:]
      
      for date in dates {
        dailyDataDict[date] = []
        
        for group in groups {
          let todos = try MyToDo.fetchAll(db, sql: "SELECT * FROM \(MyToDo.databaseTableName) WHERE groupId = ? AND date = ?", arguments: [group.groupId, date])
          
          let totalTodos = todos.count
          let completedTodos = todos.filter { $0.isDone }.count
          let progressRate = totalTodos > 0 ? Double(completedTodos) / Double(totalTodos) : 0.0
          
          let todoListGroup = TodoListGroup(
            localId: group.groupId.lowercased(),
            name: group.name,
            color: group.color,
            todoList: todos.isEmpty ? nil : todos.map { todo in
              TodoListItem(
                name: todo.name,
                endDay: todo.endDay,
                isDone: todo.isDone,
                localID: todo.todoId.lowercased(),
                startDay: todo.startDay,
                alarmTime: todo.alarmTime,
                isAlarmOn: todo.isAlarmOn,
                isOnlyToday: todo.isOnlyToday,
                repeatToDoId: todo.repeatToDoId
              )
            },
            progressRate: progressRate
          )
          
          dailyDataDict[date]?.append(todoListGroup)
        }
      }
      
      return dailyDataDict.map { DailyToDoListData(date: $0.key, list: $0.value) }
    }
  }
}
// swiftlint: enable all
