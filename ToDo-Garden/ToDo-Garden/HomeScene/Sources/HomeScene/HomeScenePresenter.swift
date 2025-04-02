//
//  HomeScenePresenter.swift
//  HomeScene
//
//  Created by Noah on 1/9/25.
//  Copyright (c) 2025 ToDoGarden. All rights reserved.

import UIKit

import HomeSceneEntity
import SharedEntity
import TDFoundation
import ToDoGardenUIComponent

@MainActor
protocol HomeScenePresentationLogic {
  func presentFetchedToDoList(monthlyData: [DailyToDoListData])
  func presentDailyToDoList(dailyData: [SharedEntity.TodoListGroup])
  func presentCreateToDo(newToDo: TodoBatchItem)
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
  
  func presentDailyToDoList(dailyData: [SharedEntity.TodoListGroup]) {
    let snapshot = self.makeNewSnapshotSections(dailyToDoList: dailyData)
    self.viewController?.displayDailyToDoList(snapshot: snapshot)
  }
  
  func presentCreateToDo(newToDo: TodoBatchItem) {
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
    private func makeHashTable(monthlyData: [DailyToDoListData]) -> [String: [SharedEntity.TodoListGroup]] {
    var hashTable: [String: [SharedEntity.TodoListGroup]] = [:]

    for data in monthlyData {
      let date = data.date.toYYYYMMDDStringFromISO8601()
      if hashTable[date] == nil {
        hashTable[date] = []
      }
      
      hashTable[date]?.append(contentsOf: data.list)
    }
    
    return hashTable
  }
  
  private func makeNewSnapshotSections(dailyToDoList: [SharedEntity.TodoListGroup]) -> ToDoListView.Snapshot {
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

  func generateSections(from group: SharedEntity.TodoListGroup) -> [ToDoListView.ToDoSection] {
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
