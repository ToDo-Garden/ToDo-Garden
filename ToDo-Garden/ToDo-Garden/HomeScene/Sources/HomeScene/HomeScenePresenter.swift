//
//  HomeScenePresenter.swift
//  HomeScene
//
//  Created by Noah on 1/9/25.
//  Copyright (c) 2025 ToDoGarden. All rights reserved.

import UIKit

import HomeSceneEntity
<<<<<<< HEAD
import SharedEntity
=======
import TDFoundation
>>>>>>> fc930727 (#907: 변경사항 반영)
import ToDoGardenUIComponent

@MainActor
protocol HomeScenePresentationLogic {
<<<<<<< HEAD
  func presentFetchedToDoList(monthlyData: [HomeScene.FetchToDoList.Response])
  func presentDailyToDoList(dailyData: [SharedEntity.TodoListGroup])
  func presentCreateToDo(newToDo: SharedEntity.TodoBatchItem)
=======
  func presentFetchedToDoList(monthlyData: [DailyToDoListData])
  func presentDailyToDoList(dailyData: [TodoListGroup])
  func presentCreateToDo(newToDo: TodoBatchItem)
>>>>>>> fc930727 (#907: 변경사항 반영)
  func presentDeleteToDo(groupID: UUID, deletedToDo: ToDoListView.ToDoItem)
  func presentErrorToast(error: Error)
  func presentDataForEditToDoScene()
}

@MainActor
final class HomeScenePresenter {
  weak var viewController: (any HomeSceneDisplayLogic)?
}

// MARK: - Request to ViewController

extension HomeScenePresenter: HomeScenePresentationLogic {
  func presentFetchedToDoList(monthlyData: [DailyToDoListData]) {
    let hashTable = self.makeHashTable(monthlyData: monthlyData)
    self.viewController?.displayFetchedToDoList(fetchedData: hashTable)
  }
  
<<<<<<< HEAD
  func presentDailyToDoList(dailyData: [SharedEntity.TodoListGroup]) {
=======
  func presentDailyToDoList(dailyData: [TodoListGroup]) {
>>>>>>> fc930727 (#907: 변경사항 반영)
    let snapshot = self.makeNewSnapshotSections(dailyToDoList: dailyData)
    self.viewController?.displayDailyToDoList(snapshot: snapshot)
  }
  
<<<<<<< HEAD
  func presentCreateToDo(newToDo: SharedEntity.TodoBatchItem) {
=======
  func presentCreateToDo(newToDo: TodoBatchItem) {
>>>>>>> fc930727 (#907: 변경사항 반영)
    self.viewController?.displayCreateToDo(newToDo: newToDo)
  }
  
  func presentDeleteToDo(groupID: UUID, deletedToDo: ToDoListView.ToDoItem) {
    self.viewController?.displayDeleteToDo(groupID: groupID, deletedToDo: deletedToDo)
  }
  
  func presentErrorToast(error: any Error) {
    self.viewController?.displayErrorToast(error: error)
  }

  func presentDataForEditToDoScene() {
    self.viewController?.routeToEditToDoScene()
  }
}

// swiftlint: disable all
extension HomeScenePresenter {
<<<<<<< HEAD
  private func makeHashTable(monthlyData: [HomeScene.FetchToDoList.Response]) -> [String: [SharedEntity.TodoListGroup]] {
    var hashTable: [String: [SharedEntity.TodoListGroup]] = [:]

=======
  private func makeHashTable(monthlyData: [DailyToDoListData]) -> [String: [TodoListGroup]] {
    var hashTable: [String: [TodoListGroup]] = [:]
    
>>>>>>> fc930727 (#907: 변경사항 반영)
    for data in monthlyData {
      let date = data.date.toYYYYMMDDStringFromISO8601()
      if hashTable[date] == nil {
        hashTable[date] = []
      }
      
      hashTable[date]?.append(contentsOf: data.list)
    }
    
    return hashTable
  }
  
<<<<<<< HEAD
  private func makeNewSnapshotSections(dailyToDoList: [SharedEntity.TodoListGroup]) -> ToDoListView.Snapshot {
=======
  private func makeNewSnapshotSections(dailyToDoList: [TodoListGroup]) -> ToDoListView.Snapshot {
>>>>>>> fc930727 (#907: 변경사항 반영)
    var snapshot = ToDoListView.Snapshot()
    dailyToDoList.forEach { group in
      let sections = self.generateSections(from: group)
      
      sections.forEach { section in
        snapshot.appendSections([section])
        snapshot.appendItems(section.getToDoItems(), toSection: section)
      }
    }
    
    return snapshot
  }

<<<<<<< HEAD
  func generateSections(from group: SharedEntity.TodoListGroup) -> [ToDoListView.ToDoSection] {
=======
  func generateSections(from group: TodoListGroup) -> [ToDoListView.ToDoSection] {
>>>>>>> fc930727 (#907: 변경사항 반영)
    guard let groupID = UUID(uuidString: group.localId) else { return [] }

    let toDoItems: [ToDoListView.ToDoItem] = group.todoList?.map { todo in
      let todoID = UUID(uuidString: todo.localID)
        return ToDoListView.ToDoItem(
          id: todoID ?? UUID(),
          toDoUIModel: .init(text: todo.name, foregroundColor: self.getColor(for: group.color), isSelected: todo.isDone, hasAlert: todo.isAlarmOn)
        )
    } ?? [] 
    
    let section = ToDoListView.ToDoSection(
      id: groupID,
      headerUIModel: .init(
        progressColor: self.getColor(for: group.color),
        progressRate: group.progressRate,
        groupTitle: group.name
      ),
      toDoItems: toDoItems
    )
    
    return [section]
  }
  
  private func getColor(for hex: String) -> UIColor {
    do {
      let color = try UIColor().fromHex(hex)
      return color
    } catch {
      return UIColor.toDoGardenGray
    }
  }
}
// swiftlint: enable all
