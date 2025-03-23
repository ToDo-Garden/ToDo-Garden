//
//  HomeScenePresenter.swift
//  HomeScene
//
//  Created by Noah on 1/9/25.
//  Copyright (c) 2025 ToDoGarden. All rights reserved.

import UIKit

import HomeSceneEntity
import ToDoGardenUIComponent

@MainActor
protocol HomeScenePresentationLogic {
  func presentFetchedToDoList(monthlyData: [HomeScene.FetchToDoList.Response])
  func presentDailyToDoList(dailyData: [HomeScene.TodoListGroup])
  func presentCreateToDo()
  func presentDeleteToDo()
}

@MainActor
final class HomeScenePresenter {
  weak var viewController: (any HomeSceneDisplayLogic)?
}

// MARK: - Request to ViewController

extension HomeScenePresenter: HomeScenePresentationLogic {
  func presentFetchedToDoList(monthlyData: [HomeScene.FetchToDoList.Response]) {
    let hashTable = self.makeHashTable(monthlyData: monthlyData)
    self.viewController?.displayFetchedToDoList(fetchedData: hashTable)
  }
  
  func presentDailyToDoList(dailyData: [HomeScene.TodoListGroup]) {
    let snapshot = self.makeNewSnapshotSections(dailyToDoList: dailyData)
    self.viewController?.displayDailyToDoList(snapshot: snapshot)
  }
  
  func presentCreateToDo() {
    self.viewController?.displayCreateToDo()
  }
  
  func presentDeleteToDo() {
    self.viewController?.displayDeleteToDo()
  }
}

extension HomeScenePresenter {
  private func makeHashTable(monthlyData: [HomeScene.FetchToDoList.Response]) -> [String: [HomeScene.TodoListGroup]] {
    var hashTable: [String: [HomeScene.TodoListGroup]] = [:]
    
    for data in monthlyData {
      let date = data.date
      if hashTable[date] == nil {
        hashTable[date] = []
      }
      
      hashTable[date]?.append(contentsOf: data.list)
    }
    
    return hashTable
  }
  
  private func makeNewSnapshotSections(dailyToDoList: [HomeScene.TodoListGroup]) -> ToDoListView.Snapshot {
    var snapshot = ToDoListView.Snapshot()
    dailyToDoList.forEach { group in
      let sections = self.generateSections(from: group)
      
      sections.forEach { section in
        snapshot.appendSections([section])
        snapshot.appendItems(section.toDoItems, toSection: section)
      }
    }
    
    return snapshot
  }

  func generateSections(from group: HomeScene.TodoListGroup) -> [ToDoListView.ToDoSection] {
    let toDoItems = group.todoList?.map { todo in
      ToDoListView.ToDoItem(
        toDoUIModel: .init(text: todo.name, foregroundColor: self.getColor(for: group.color))
      )
    } ?? []
    
    let section = ToDoListView.ToDoSection(
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
