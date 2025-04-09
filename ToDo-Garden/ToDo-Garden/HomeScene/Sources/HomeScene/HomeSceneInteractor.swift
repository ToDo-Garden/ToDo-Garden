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
  func fetchToDoList(request: HomeScene.FetchToDoList.Request) async
  func createToDo(group: ToDoListView.ToDoSection, date: Date) async
  func deleteToDo(group: ToDoListView.ToDoSection, todo: ToDoListView.ToDoItem, date: Date) async
  func setMonthlyData(_ monthlyData: [String: [SharedEntity.TodoListGroup]]) async
  func loadDailyToDoList(targetDate: String) async
  func updateText(text: String, indexPath: IndexPath, date: Date)
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
    if self.checkNetworkConnection() {
      do {
        try await self.homeSceneWorker.syncronizeServerEditGroups()
      } catch let error {
        self.handleErrors(error)
      }
    } else {
      return
    }
  }
  
  
  func fetchToDoList(request: HomeScene.FetchToDoList.Request) async {
    if self.checkNetworkConnection() {
      do {
        let fetchedToDoList = try await self.homeSceneWorker.fetchToDoList(dateString: request.dateString)
        self.presenter?.presentFetchedToDoList(monthlyData: fetchedToDoList)
      } catch let error {
        self.handleErrors(error)
      }
    } else {
      do {
        let (newMonthlyData, response) = try await self.loadMonthlyToDoListFromGRDB(request: request)
        self.monthlyData = newMonthlyData
        self.presenter?.presentFetchedToDoList(monthlyData: response)
      } catch let error {
        self.handleErrors(error)
      }
    }
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
  
  func requestBatchUpdateToServer() async {
    if self.checkNetworkConnection() {
      do {
        try await self.homeSceneWorker.requestBatchUpdateToServer()
        self.itemsForBatch.removeAll()
      } catch let error {
        self.handleErrors(error)
      }
    } else {
      do {
        try await self.homeSceneWorker.syncronizeGRDBWithBatchItems()
      } catch let error {
        self.handleErrors(error)
      }
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
        groupId: targetGroup.localId, isDelete: false
      )
    }
  }

  // EditToDoScene으로 넘겨주기 위한 데이터를 준비하는 작업입니다.
  func prepareDataForEditTodoScene(request: HomeScene.PrepareDataForEditToDoScene.Request) {
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
  
  private func makeItemForCreateToDo(group: ToDoListView.ToDoSection, date: Date) -> TodoBatchItem {
    let newToDoID = UUID()
    let groupID = group.id.uuidString.lowercased()
    let newItem = TodoBatchItem(
      localId: newToDoID.uuidString.lowercased(),
      name: "New ToDo",
      isDone: false,
      createdAt: date.toISOString(),
      isAlarmOn: false,
      alarmTime: 0, // 기본값 뭐임?
      isOnlyToday: true,
      startDay: nil,
      endDay: nil,
      groupId: groupID,
      isDelete: false
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
      isDelete: true
    )
    return deletedItem
  }
  
  private func makeToDoListItem(batchItem: TodoBatchItem) -> TodoListItem {
    let todoListItem = TodoListItem(
      name: batchItem.name,
      endDay: nil,
      isDone: false,
      localID: batchItem.localId.lowercased(),
      startDay: nil,
      alarmTime: nil,
      isAlarmOn: false,
      isOnlyToday: true,
      repeatToDoId: nil // TODO: 이건 어떻게 특정하지?
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
