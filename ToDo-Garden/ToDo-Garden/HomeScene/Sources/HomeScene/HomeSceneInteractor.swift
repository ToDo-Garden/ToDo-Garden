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
import SharedEntity
import ToDoGardenUIComponent

@MainActor
protocol HomeSceneDataStore {
  var toDo: SharedEntity.TodoBatchItem? { get set }
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
  func writeJSONFile() async
  func requestBatchUpdateToServer() async
  func prepareDataForEditTodoScene(request: HomeScene.PrepareDataForEditToDoScene.Request)
}

@MainActor
final class HomeSceneInteractor: HomeSceneDataStore {
  var presenter: (any HomeScenePresentationLogic)?
  private var homeSceneWorker: HomeSceneWorkable
  private var monthlyData: [String: [SharedEntity.TodoListGroup]]
  // ⬆️ 서버에서 받아오는 1달짜리 데이터입니다. ex) key = "20250302"
  private var itemsForBatch: [String: SharedEntity.TodoBatchItem]
  // ⬆️ JSONStorage가 매번 fileWrite를 하기엔 부담스러워서 모아놨다가 적절한 순간에 fileWrite를 진행하기 위한 데이터입니다.
  // 즉, 서버에게 배치처리를 요청하기 위한 배치처리 과정이라고 볼 수 있습니다.
  // ex) key = ToDo의 UUIDString
  // ex) key = "20250302"

  var toDo: SharedEntity.TodoBatchItem?
  var groups: [SharedEntity.TodoListGroup]?
  // ⬆️ 투두 수정화면에서 필요한 데이터입니다.

  init(homeSceneWorker: HomeSceneWorkable) {
    self.homeSceneWorker = homeSceneWorker
    self.monthlyData = [:]
    self.itemsForBatch = [:]
  }
}

// MARK: - Request to worker
// swiftlint: disable all
extension HomeSceneInteractor: HomeSceneBusinessLogic {
  func fetchToDoList(request: HomeScene.FetchToDoList.Request) async {
    do {
      let fetchedToDoList = try await self.homeSceneWorker.fetchToDoList(dateString: request.dateString)
      self.presenter?.presentFetchedToDoList(monthlyData: fetchedToDoList)
    } catch let error {
      self.handleErrors(error)
    }
  }
  
  func loadDailyToDoList(targetDate: String) async {
    let formattedDate = targetDate.toYYYYMMDDStringFromISO8601Space()
    let dailyToDoList: [SharedEntity.TodoListGroup] = self.monthlyData[formattedDate] ?? []
    
    self.presenter?.presentDailyToDoList(dailyData: dailyToDoList)
  }
  
  func createToDo(group: ToDoListView.ToDoSection, date: Date) async {
    let dateString = date.description.toYYYYMMDDStringFromISO8601Space()
    let newToDo = self.makeItemForCreateToDo(group: group, date: date)
    self.addBatchItem(newToDo: newToDo)
    
    if let targetGroupIndex = self.monthlyData[dateString]?.firstIndex(
      where: { UUID(uuidString: $0.localId) == group.id }
    ) {
      let targetGroup = self.monthlyData[dateString]?[targetGroupIndex]
      targetGroup?.todoList?.append(self.makeToDoListItem(batchItem: newToDo))
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
      self.itemsForBatch[targetToDo.localID] = SharedEntity.TodoBatchItem(
        localId: targetToDo.localID, name: text, isDone: targetToDo.isDone,
        createdAt: date.toISOString(), isAlarmOn: targetToDo.isAlarmOn, alarmTime: alarmTime,
        isOnlyToday: targetToDo.isOnlyToday, startDay: targetToDo.startDay, endDay: targetToDo.endDay,
        groupId: targetGroup.localId, isDelete: false
      )
    }
  }
  
  func writeJSONFile() async {
    guard !self.itemsForBatch.values.isEmpty else { return }
    
    do {
      let data = Array(self.itemsForBatch.values)
      try await self.homeSceneWorker.writeJSONFile(data: data)
      self.itemsForBatch.removeAll()
    } catch let error {
      self.handleErrors(error)
    }
  }
  
  func requestBatchUpdateToServer() async {
    do {
      try await self.homeSceneWorker.requestBatchUpdateToServer()
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
      self.itemsForBatch[targetToDo.localID] = SharedEntity.TodoBatchItem(
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
    print(request.groupId.uuidString.lowercased())
    print(groups?[1].localId == request.groupId.uuidString.lowercased())
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
  ) -> SharedEntity.TodoBatchItem {
    return SharedEntity.TodoBatchItem(
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
  private func addBatchItem(newToDo: SharedEntity.TodoBatchItem) {
    self.itemsForBatch[newToDo.localId] = newToDo
  }
  
  private func removeBatchItem(deletedToDo: SharedEntity.TodoBatchItem) {
    if self.itemsForBatch[deletedToDo.localId] == nil {
      self.itemsForBatch[deletedToDo.localId] = deletedToDo
    } else {
      self.itemsForBatch[deletedToDo.localId]?.isDelete = true
    }
  }
  
  private func makeItemForCreateToDo(group: ToDoListView.ToDoSection, date: Date) -> SharedEntity.TodoBatchItem {
    let newToDoID = UUID()
    let groupID = group.id.uuidString
    let newItem = SharedEntity.TodoBatchItem(
      localId: newToDoID.uuidString,
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
  
  private func makeItemForDeleteToDo(group: ToDoListView.ToDoSection, todo: SharedEntity.TodoListItem, date: Date) -> SharedEntity.TodoBatchItem {
    let groupID = group.id.uuidString
    let alarmTime = Double(todo.alarmTime ?? 0)
    
    let deletedItem = SharedEntity.TodoBatchItem(
      localId: todo.localID,
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
  
  private func makeToDoListItem(batchItem: SharedEntity.TodoBatchItem) -> SharedEntity.TodoListItem {
    let todoListItem = SharedEntity.TodoListItem(
      name: batchItem.name,
      endDay: nil,
      isDone: false,
      localID: batchItem.localId,
      startDay: nil,
      alarmTime: nil,
      isAlarmOn: false,
      isOnlyToday: true,
      repeatToDoId: nil // TODO: 이건 어떻게 특정하지?
    )
    return todoListItem
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
