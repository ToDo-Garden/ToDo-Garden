//
//  HomeSceneInteractor.swift
//  HomeScene
//
//  Created by Noah on 1/9/25.
//  Copyright (c) 2025 ToDoGarden. All rights reserved.

import UIKit

import FoundationExtension
import HomeSceneAPI
import HomeSceneEntity
import HTTPClientAPI
import SharedEntity
import TDFoundation
import ToDoGardenUIComponent

@MainActor
protocol HomeSceneDataStore {
  var toDo: TodoBatchItem? { get set }
  var groups: [SharedEntity.TodoListGroup]? { get set }
}

@MainActor
protocol HomeSceneBusinessLogic {
  func fetchToDoList(request: HomeScene.FetchToDoList.Request, isForRouting: Bool) async
  func createToDo(group: ToDoListView.ToDoSection, date: Date) async
  func deleteToDo(group: ToDoListView.ToDoSection, todo: ToDoListView.ToDoItem, date: Date) async
  func setMonthlyData(_ monthlyData: [String: [SharedEntity.TodoListGroup]]) async
  func loadDailyToDoList(targetDate: String) async
  func updateText(text: String, indexPath: IndexPath, date: Date)
  func updateToDo(
    group: ToDoListView.ToDoSection, batchItem: TodoBatchItem,
    indexPath: IndexPath, date: Date, isNeededDeletionBySelection: Bool
  ) async
  func updateSelection(isSelected: Bool, indexPath: IndexPath, date: Date)
  func writeBatchItemsToGRDB() async
  func requestBatchUpdateToServer() async
  func prepareDataForEditTodoScene(request: HomeScene.PrepareDataForEditToDoScene.Request)
  func syncronizeServerEditGroups() async
}

@MainActor
final class HomeSceneInteractor: HomeSceneDataStore {
  var homeSceneDelegate: ((Int) -> Void)?
  var presenter: (any HomeScenePresentationLogic)?
  private let retryManager: NetworkRetryManagerAPI
  private var homeSceneWorker: HomeSceneWorkable
  private var monthlyData: [String: [SharedEntity.TodoListGroup]]
  // ⬆️ 서버에서 받아오는 1달짜리 데이터입니다. ex) key = "20250302"
  private var itemsForBatch: [String: TodoBatchItem] 
  // ⬆️ JSONStorage가 매번 fileWrite를 하기엔 부담스러워서 모아놨다가 적절한 순간에 fileWrite를 진행하기 위한 데이터입니다.
  // 즉, 서버에게 배치처리를 요청하기 위한 배치처리 과정이라고 볼 수 있습니다.
  // ex) key = ToDo의 UUIDString
  // ex) key = "20250302"

  var toDo: TodoBatchItem?
  var groups: [SharedEntity.TodoListGroup]?
  // ⬆️ 투두 수정화면에서 필요한 데이터입니다.

  init(
    homeSceneWorker: HomeSceneWorkable,
    retryManager: NetworkRetryManagerAPI
  ) {
    self.homeSceneWorker = homeSceneWorker
    self.retryManager = retryManager
    self.monthlyData = [:]
    self.itemsForBatch = [:]
    self.retryManager.execute(isRetryingOn: false)
    self.setupNotificationObserver()
  }
}

// MARK: - Request to worker
// swiftlint: disable all
extension HomeSceneInteractor: HomeSceneBusinessLogic {
  func syncronizeServerEditGroups() async {
    await FallbackFlow.run(
      online: { [weak self] in
        guard let self = self else { return }
        
        try await self.homeSceneWorker.syncronizeServerEditGroups()
      },
      offline: { return },
      handleError: { [weak self] error in
        self?.handleErrors(error)
      },
      checkNetworkConnection: { [weak self] in
        guard let self = self else { return false }
        
        return self.checkNetworkConnection()
      }
    )
  }
  
  func fetchToDoList(request: HomeScene.FetchToDoList.Request, isForRouting: Bool) async {
    await FallbackFlow.run(
      online: { [weak self] in
        guard let self = self else { return }
        
        let fetchedToDoList = try await self.homeSceneWorker.fetchToDoList(dateString: request.dateString)
        if isForRouting == false {
          self.presenter?.presentFetchedToDoList(monthlyData: fetchedToDoList)
        }
      },
      offline: { [weak self] in
        guard let self = self else { return }
        
        let (newMonthlyData, response) = try await self.loadMonthlyToDoListFromGRDB(request: request)
        self.monthlyData = newMonthlyData
        if isForRouting == false {
          self.presenter?.presentFetchedToDoList(monthlyData: response)
        }
      },
      handleError: { [weak self] error in
        self?.handleErrors(error)
      },
      checkNetworkConnection: { [weak self] in
        guard let self = self else { return false }
        
        return self.checkNetworkConnection()
      }
    )
  }
  
  func requestBatchUpdateToServer() async {
    await FallbackFlow.run(
      online: { [weak self] in
        guard let self = self else { return }
        
        try await self.homeSceneWorker.requestBatchUpdateToServer()
        self.itemsForBatch.removeAll()
      },
      offline: { [weak self] in
        guard let self = self else { return }
        
        try await self.homeSceneWorker.syncronizeGRDBWithBatchItems()
      },
      handleError: { [weak self] error in
        self?.handleErrors(error)
      },
      checkNetworkConnection: { [weak self] in
        guard let self = self else { return false }
        
        return self.checkNetworkConnection()
      }
    )
  }
  
  func loadDailyToDoList(targetDate: String) async {
    let formattedDate = targetDate.toYYYYMMDDStringFromISO8601Space()
    let dailyToDoList: [SharedEntity.TodoListGroup] = self.monthlyData[formattedDate] ?? []
    
    self.presenter?.presentDailyToDoList(dailyData: dailyToDoList)
  }
  
  func loadMonthlyToDoListFromGRDB(request: HomeScene.FetchToDoList.Request) async throws -> ([String: [TodoListGroup]], [DailyToDoListData])
  {
    let localMonthlyData = try await self.homeSceneWorker.loadMonthlyToDoListFromGRDB(dateString: request.dateString)
    var newMonthlyData: [String: [TodoListGroup]] = [:]
 
    for dailyData in localMonthlyData {
      newMonthlyData[dailyData.date] = dailyData.list
    }
    return (newMonthlyData, localMonthlyData)
  }
  
  func createToDo(group: ToDoListView.ToDoSection, date: Date) async {
    let dateString = date.description.toYYYYMMDDStringFromISO8601Space()
    let newToDo = self.makeItemForCreateToDo(group: group, date: date)
    self.addBatchItem(newToDo: newToDo)
    
    if let targetGroupIndex = self.monthlyData[dateString]?.firstIndex(
      where: { UUID(uuidString: $0.localId) == group.id }
    ) {
      let targetGroup = self.monthlyData[dateString]?[targetGroupIndex]
      let newItem = self.makeToDoListItem(batchItem: newToDo)
      if targetGroup?.todoList == nil {
        targetGroup?.todoList = [newItem]
      } else {
        targetGroup?.todoList?.append(newItem)
      }
    }
  
    self.presenter?.presentCreateToDo(newToDo: newToDo)
  }
  
  func deleteToDo(group:ToDoListView.ToDoSection, todo: ToDoListView.ToDoItem, date: Date) async {
    let dateString = date.description.toYYYYMMDDStringFromISO8601Space()
    var deletedToDo: SharedEntity.TodoListItem? = nil

    if let targetGroupIndex = self.monthlyData[dateString]?.firstIndex(
      where: { UUID(uuidString: $0.localId) == group.id }
    ) {
      let targetGroup = self.monthlyData[dateString]?[targetGroupIndex]
      if let targetToDoIndex = targetGroup?.todoList?.firstIndex(
        where: { UUID(uuidString: $0.localID) == todo.id }
      ) {
        deletedToDo = self.monthlyData[dateString]?[targetGroupIndex].todoList?[targetToDoIndex]
        self.monthlyData[dateString]?[targetGroupIndex].todoList?.remove(at: targetToDoIndex)
      }
    }
    
    if deletedToDo != nil {
      let batchItem = self.makeItemForDeleteToDo(group: group, todo: deletedToDo!, date: date)
      self.removeBatchItem(deletedToDo: batchItem)
    }
    self.presenter?.presentDeleteToDo(groupID: group.id, deletedToDo: todo)
  }
  
  func setMonthlyData(_ monthlyData: [String: [SharedEntity.TodoListGroup]]) async {
    self.monthlyData = monthlyData
  }
  
  func updateText(text: String, indexPath: IndexPath, date: Date) {
    let targetDate = date.description.toYYYYMMDDStringFromISO8601Space()
    guard let targetGroup = self.monthlyData[targetDate]?[indexPath.section],
      let targetToDo = targetGroup.todoList?[indexPath.item] else { return }
    
    if targetToDo.name == text { return } // 텍스트에 변경사항이 없으면 그냥 리턴
    
    targetToDo.name = text
    if let batchItem = self.itemsForBatch[targetToDo.localID] {
      batchItem.setName(text)
    } else {
      let alarmTime = Double(targetToDo.alarmTime ?? 0)

      self.itemsForBatch[targetToDo.localID] = TodoBatchItem(
        localId: targetToDo.localID, name: text, isDone: targetToDo.isDone,
        createdAt: date.toISOString(), isAlarmOn: targetToDo.isAlarmOn, alarmTime: alarmTime,
        isOnlyToday: targetToDo.isOnlyToday, startDay: targetToDo.startDay, endDay: targetToDo.endDay,
        groupId: targetGroup.localId.lowercased(), isDelete: false
      )
    }
  }

  // 투두 수정 화면에서 수정된 데이터를 반영하는 메서드입니다.
  func updateToDo(
    group: ToDoListView.ToDoSection,
    batchItem: TodoBatchItem,
    indexPath: IndexPath,
    date: Date,
    isNeededDeletionBySelection: Bool
  ) async {
    let targetDate = date.description.toYYYYMMDDStringFromISO8601Space()
    guard let targetGroup = self.monthlyData[targetDate]?[indexPath.section],
      let targetToDo = targetGroup.todoList?[indexPath.item] else { return }

    switch self.getRepetitionStatus(toDo: targetToDo, batchItem: batchItem) {
    case .made:
      self.addRepeatToDos(
        batchItem: batchItem, targetToDo: targetToDo, group: group, indexPath: indexPath, date: date
      )
    case .changed:
      await self.updateRepeatToDos(
        batchItem: batchItem, targetToDo: targetToDo, group: group,
        indexPath: indexPath, date: date
      )
    case .deleted:
      await self.removeRepeatToDos(
        batchItem: batchItem, targetToDo: targetToDo,
        group: group, indexPath: indexPath, date: date,
        isNeededDeletionBySelection: isNeededDeletionBySelection
      )
    default:
      break
    }

    targetToDo.name = batchItem.name
    targetToDo.isAlarmOn = batchItem.isAlarmOn
    targetToDo.alarmTime = Int(batchItem.alarmTime)
    targetToDo.isOnlyToday = batchItem.isOnlyToday
    targetToDo.startDay = batchItem.startDay
    targetToDo.endDay = batchItem.endDay
    self.itemsForBatch[targetToDo.localID] = batchItem
  }

  func writeBatchItemsToGRDB() async {
    guard !self.itemsForBatch.values.isEmpty else { return }
    
    do {
      let data = Array(self.itemsForBatch.values)
      try await self.homeSceneWorker.writeBatchItemsToGRDB(data: data)
      self.itemsForBatch.removeAll()
    } catch let error {
      self.handleErrors(error)
    }
  }
  
  func updateSelection(isSelected: Bool, indexPath: IndexPath, date: Date) {
    let targetDate = date.description.toYYYYMMDDStringFromISO8601Space()
    guard let targetGroup = self.monthlyData[targetDate]?[indexPath.section],
      let targetToDo = targetGroup.todoList?[indexPath.item] else { return }
    
    if isSelected == targetToDo.isDone { return }
    targetToDo.isDone = isSelected
    if let batchItem = self.itemsForBatch[targetToDo.localID] {
      batchItem.setDone(isSelected)
    } else {
      let alarmTime = Double(targetToDo.alarmTime ?? 0)
      self.itemsForBatch[targetToDo.localID] = TodoBatchItem(
        localId: targetToDo.localID, name: targetToDo.name, isDone: isSelected,
        createdAt: date.toISOString(), isAlarmOn: targetToDo.isAlarmOn, alarmTime: alarmTime,
        isOnlyToday: targetToDo.isOnlyToday, startDay: targetToDo.startDay, endDay: targetToDo.endDay,
        groupId: targetGroup.localId, isDelete: false, repeatToDoId: targetToDo.repeatToDoId
      )
    }
  }

  // EditToDoScene으로 넘겨주기 위한 데이터를 준비하는 작업입니다.
  func prepareDataForEditTodoScene(request: HomeScene.PrepareDataForEditToDoScene.Request) {
    Task {
      try await self.homeSceneWorker.syncronizeGRDBWithBatchItems()
    }
    let dateString = request.selectedDate.description.toYYYYMMDDStringFromISO8601Space()
    let groups = self.monthlyData[dateString]
    let group = groups?.first(where: { (group: SharedEntity.TodoListGroup) in
      return group.localId.lowercased() == request.groupId.uuidString.lowercased()
    })!
    let todo = group?.todoList?.first(where: { (todo: SharedEntity.TodoListItem) in
      return todo.localID.lowercased() == request.todoId.uuidString.lowercased()
    })!

    self.groups = groups
    self.toDo = self.makeToDoBatchItem(from: todo!, groupId: group!.localId, dateString: dateString)
    self.presenter?.presentDataForEditToDoScene()
  }

  private func makeToDoBatchItem(
    from todo: SharedEntity.TodoListItem,
    groupId: String,
    dateString: String
  ) -> TodoBatchItem {
    return TodoBatchItem(
      localId: todo.localID,
      name: todo.name,
      isDone: todo.isDone,
      createdAt: dateString,
      isAlarmOn: todo.isAlarmOn,
      alarmTime: Double(todo.alarmTime ?? 0),
      isOnlyToday: todo.isOnlyToday,
      startDay: todo.startDay,
      endDay: todo.endDay,
      groupId: groupId,
      isDelete: false
    )
  }
}

// MARK: 투두 반복 관련 함수입니다.

extension HomeSceneInteractor {
  private func getRepetitionStatus(toDo: TodoListItem, batchItem: TodoBatchItem) -> RepetitionStatus {
    if toDo.isOnlyToday && batchItem.isOnlyToday == false {
      return .made
    } else if toDo.isOnlyToday == false
      && batchItem.isOnlyToday == false
      && (toDo.startDay != batchItem.startDay || toDo.endDay != batchItem.endDay)
    {
      return .changed
    } else if toDo.isOnlyToday == false && batchItem.isOnlyToday {
      return .deleted
    }

    return .unknown
  }

  private func addRepeatToDos(
    batchItem: TodoBatchItem,
    targetToDo: TodoListItem,
    group: ToDoListView.ToDoSection,
    indexPath: IndexPath,
    date: Date
  ) {
    let formatter = ISO8601DateFormatter()
    guard
        let startDayString = batchItem.startDay,
        let endDayString = batchItem.endDay,
        let startDate = formatter.date(from: startDayString)?.toKSTDate(),
        let endDate = formatter.date(from: endDayString)?.toKSTDate(),
        let targetGroup = self.groups?.first(where: { $0.localId == batchItem.groupId })
      else { return }
    
    var currentDate = startDate
    while currentDate <= endDate {
      if currentDate == date.toKSTDate() {
        currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        continue
      }
      
      let newToDoID = UUID()
      let newBatchItem = self.makeItemForCreateToDo(group: group, newGroupId: targetGroup.localId, newToDoID: newToDoID, date: currentDate, isOnlyToday: false, repeatToDoId: targetToDo.localID)
      newBatchItem.setName(batchItem.name)
      self.addBatchItem(newToDo: newBatchItem)
      currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
    }
  }

  private func updateRepeatToDos(
    batchItem: TodoBatchItem,
    targetToDo: TodoListItem,
    group: ToDoListView.ToDoSection,
    indexPath: IndexPath,
    date: Date
  ) async {
    do {
      let formatter = ISO8601DateFormatter()
      guard
        let startDayString = batchItem.startDay,
        let endDayString = batchItem.endDay,
        let startDate = formatter.date(from: startDayString),
        let endDate = formatter.date(from: endDayString),
        let targetGroup = self.groups?.first(where: { $0.localId == batchItem.groupId })
      else { return }

      var currentDate = startDate
      let oldTodos = try await self.homeSceneWorker.getRepeatToDos(repeatToDoId: batchItem.localId)
      for oldTodo in oldTodos {
        if oldTodo.todoId.lowercased() == batchItem.localId.lowercased() {
          continue
        }
        
        let batchItem = self.makeBatchItemFrom(myToDo: oldTodo, isDelete: true)
        self.removeBatchItem(deletedToDo: batchItem)
      }
      await self.writeBatchItemsToGRDB()
      
      try await self.homeSceneWorker.clearRepeatToDos(repeatToDoId: batchItem.localId)
      
      while currentDate <= endDate {
        if currentDate.toStringYYYYMMDD() == date.toStringYYYYMMDD() {
          currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
          continue
        }
        
        let newToDoID = UUID()
        let newToDo = self.makeItemForCreateToDo(group: group, newGroupId: targetGroup.localId, newToDoID: newToDoID, date: currentDate, isOnlyToday: false, repeatToDoId: targetToDo.localID)
        
        newToDo.setName(batchItem.name)
        self.addBatchItem(newToDo: newToDo)
        currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
      }
      
    } catch let error {
      self.handleErrors(error)
    }
  }

  private func removeRepeatToDos(
    batchItem: TodoBatchItem,
    targetToDo: TodoListItem,
    group: ToDoListView.ToDoSection,
    indexPath: IndexPath,
    date: Date,
    isNeededDeletionBySelection: Bool
  ) async {
    do {
      let oldTodos = try await self.homeSceneWorker.getRepeatToDos(repeatToDoId: batchItem.localId)
      for oldTodo in oldTodos {
        if oldTodo.todoId.lowercased() == batchItem.localId.lowercased() {
          continue
        }
        
        if isNeededDeletionBySelection == true && oldTodo.isDone == true {
          continue
        }
        
        let batchItem = self.makeBatchItemFrom(myToDo: oldTodo, isDelete: true)
        self.removeBatchItem(deletedToDo: batchItem)
      }
      await self.writeBatchItemsToGRDB()
    } catch let error {
      self.handleErrors(error)
    }
  }
}

extension HomeSceneInteractor {
  private func checkNetworkConnection() -> Bool {
    return self.retryManager.isConnected()
  }
  
  private func addBatchItem(newToDo: TodoBatchItem) {
    self.itemsForBatch[newToDo.localId] = newToDo
  }
  
  private func removeBatchItem(deletedToDo: TodoBatchItem) {
    if self.itemsForBatch[deletedToDo.localId] == nil {
      self.itemsForBatch[deletedToDo.localId] = deletedToDo
    } else {
      self.itemsForBatch[deletedToDo.localId]?.isDelete = true
    }
  }
  
  private func makeBatchItemFrom(myToDo: MyToDo, isDelete: Bool = true) -> TodoBatchItem {
    return TodoBatchItem(
      localId: myToDo.todoId.lowercased(), name: myToDo.name, isDone: myToDo.isDone,
      createdAt: myToDo.date, isAlarmOn: myToDo.isAlarmOn, alarmTime: Double.zero,
      isOnlyToday: myToDo.isOnlyToday, startDay: myToDo.startDay,
      endDay: myToDo.endDay, groupId: myToDo.groupId, isDelete: isDelete
    )
  }
  
  private func makeItemForCreateToDo(group: ToDoListView.ToDoSection, newGroupId: String? = nil, newToDoID: UUID = UUID(), date: Date, isOnlyToday: Bool = true, repeatToDoId: String? = nil) -> TodoBatchItem {

    let groupID = (newGroupId != nil) ? newGroupId! : group.id.uuidString.lowercased()
    let newItem = TodoBatchItem(
      localId: newToDoID.uuidString.lowercased(),
      name: "New ToDo",
      isDone: false,
      createdAt: date.toISOString(),
      isAlarmOn: false,
      alarmTime: 0,
      isOnlyToday: isOnlyToday,
      startDay: nil,
      endDay: nil,
      groupId: groupID,
      isDelete: false,
      repeatToDoId: repeatToDoId
    )
    return newItem
  }
  
  private func makeItemForDeleteToDo(group: ToDoListView.ToDoSection, todo: TodoListItem, date: Date) -> TodoBatchItem {
    let groupID = group.id.uuidString.lowercased()
    let alarmTime = Double(todo.alarmTime ?? 0)
    
    let deletedItem = TodoBatchItem(
      localId: todo.localID.lowercased(),
      name: todo.name,
      isDone: todo.isDone,
      createdAt: date.toISOString(),
      isAlarmOn: todo.isAlarmOn,
      alarmTime: alarmTime,
      isOnlyToday: todo.isOnlyToday,
      startDay: todo.startDay,
      endDay: todo.endDay,
      groupId: groupID,
      isDelete: true,
      repeatToDoId: todo.localID
    )
    return deletedItem
  }
  
  private func makeToDoListItem(batchItem: TodoBatchItem) -> TodoListItem {
    let todoListItem = TodoListItem(
      name: batchItem.name,
      endDay: batchItem.endDay,
      isDone: batchItem.isDone,
      localID: batchItem.localId.lowercased(),
      startDay: batchItem.startDay,
      alarmTime: Int(batchItem.alarmTime),
      isAlarmOn: batchItem.isAlarmOn,
      isOnlyToday: batchItem.isOnlyToday,
      repeatToDoId: batchItem.repeatToDoId
    )
    return todoListItem
  }
}

extension HomeSceneInteractor {
  private func setupNotificationObserver() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.handleDidBecomeActiveNotification),
      name: .init("did become active"),
      object: nil
    )
  }
  
  @objc
  private func handleDidBecomeActiveNotification() {
    let dateToString = Date.now.description.toYYYYMMDDStringFromISO8601Space()
    
    guard let dailyData = self.monthlyData[dateToString]
    else { return }
    
    let remainToDoCount = dailyData.reduce(into: 0, { $0 += $1.remainCount })
    
    self.homeSceneDelegate?(
      remainToDoCount
    )
  }
}

extension HomeSceneInteractor {
  enum RepetitionStatus {
    case made
    case changed
    case deleted
    case unknown
  }
}

extension SharedEntity.TodoListGroup {
  var remainCount: Int {
    return self.todoList?.reduce(into: 0, { $0 += $1.isDone ? 0 : 1 }) ?? 0
  }
}

// MARK: - HandleErrors

extension HomeSceneInteractor {
  private func handleErrors(_ error: Error) {
    switch error {
    default:
      self.presenter?.presentErrorToast(error: error)
    }
  }
}
// swiftlint: enable all
