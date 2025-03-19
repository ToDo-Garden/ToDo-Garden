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
  func presentFetchedToDoList(response: HomeScene.FetchToDoList.Response)
  func presentCreateToDo()
  func presentDeleteToDo()
}

@MainActor
final class HomeScenePresenter {
  weak var viewController: (any HomeSceneDisplayLogic)?
}

// MARK: - Request to ViewController

extension HomeScenePresenter: HomeScenePresentationLogic {
  func presentFetchedToDoList(response: HomeScene.FetchToDoList.Response) {
    let snapshot = self.makeNewSnapshotSections(response: response)
    self.viewController?.displayFetchedToDoList(snapshot: snapshot)
  }
  
  func presentCreateToDo() {
    self.viewController?.displayCreateToDo()
  }
  
  func presentDeleteToDo() {
    self.viewController?.displayDeleteToDo()
  }
}

extension HomeScenePresenter {
  private func makeNewSnapshotSections(response: HomeScene.FetchToDoList.Response) -> ToDoListView.Snapshot {
    var snapshot = ToDoListView.Snapshot()
    
    // 요청한 날짜의 DailyToDoList만 generateSections으로 넘기도록 수정해야함.
    if let firstDailyTodoList = response.list?.first {
      snapshot.appendSections(self.generateSections(from: firstDailyTodoList))
      snapshot.sectionIdentifiers.forEach { section in
        snapshot.appendItems(section.toDoItems, toSection: section)
      }
    }
    
    return snapshot
  }
  
  func generateSections(from dailyTodoList: HomeScene.DailyTodoList) -> [ToDoListView.ToDoSection] {
    let sections = dailyTodoList.list.map { group in
      let toDoItems = (group.todoList ?? []).map { todo in
        ToDoListView.ToDoItem(
          toDoUIModel: .init(text: todo.name, foregroundColor: self.getColor(for: group.color))
        )
      }

      return ToDoListView.ToDoSection(
        headerUIModel: .init(
          progressColor: self.getColor(for: group.color),
          progressRate: Double(group.progressRate),
          groupTitle: group.name
        ),
        toDoItems: toDoItems
      )
    }

    return sections
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
