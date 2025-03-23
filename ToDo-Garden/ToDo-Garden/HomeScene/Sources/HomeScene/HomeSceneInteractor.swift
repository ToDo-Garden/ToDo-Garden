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
import ToDoGardenUIComponent

protocol HomeSceneDataStore {
}

@MainActor
protocol HomeSceneBusinessLogic {
  func fetchToDoList(request: HomeScene.FetchToDoList.Request) async
  func createToDo() async
  func deleteToDo() async
  func setMonthlyData(_ monthlyData: [String: [HomeScene.TodoListGroup]]) async
  func loadDailyToDoList(targetDate: String) async
}

@MainActor
final class HomeSceneInteractor: HomeSceneDataStore {
  var presenter: (any HomeScenePresentationLogic)?
  private var homeSceneWorker: HomeSceneWorkable
  private var monthlyData: [String: [HomeScene.TodoListGroup]] // ex) key = "20250302"
  private var itemsForBatch: [String: HomeScene.TodoBatchItem] // ex) key = UUIDSring(ToDo-localId)
  
  init(homeSceneWorker: HomeSceneWorkable) {
    self.homeSceneWorker = homeSceneWorker
    self.monthlyData = [:]
    self.itemsForBatch = [:]
  }
}

// MARK: - Request to worker
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
    let dailyToDoList: [HomeScene.TodoListGroup] = self.monthlyData[formattedDate] ?? []
    self.presenter?.presentDailyToDoList(dailyData: dailyToDoList)
  }
  
  func createToDo() async {
    do {
      try await self.homeSceneWorker.createToDo()
      self.presenter?.presentCreateToDo()
    } catch let error {
      self.handleErrors(error)
    }
  }
  
  func deleteToDo() async {
    do {
      try await self.homeSceneWorker.deleteToDo()
      self.presenter?.presentDeleteToDo()
    } catch let error {
      self.handleErrors(error)
    }
  }
  
  func setMonthlyData(_ monthlyData: [String: [HomeScene.TodoListGroup]]) async {
    self.monthlyData = monthlyData
  }
}

// swiftlint: disable all
extension HomeSceneInteractor {
  private func makeItemForCreateToDo(group: ToDoListView.ToDoSection) -> HomeScene.TodoBatchItem {
    let newToDoID = UUID()
    let groupID = group.id.uuidString
    let newItem = HomeScene.TodoBatchItem(
      localId: newToDoID.uuidString,
      name: "New ToDo",
      isDone: false,
      createdAt: Date.now.toISOString(),
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
  
  private func makeToDoListItem(batchItem: HomeScene.TodoBatchItem) -> HomeScene.TodoListItem {
    let todoListItem = HomeScene.TodoListItem(
      name: batchItem.name,
      endDay: nil,
      isDone: false,
      localID: batchItem.localId,
      startDay: nil,
      alarmTime: nil,
      isAlarmOn: false,
      isOnlyToday: true,
      repeatToDoId: nil
    )
    return todoListItem
  }
}

// MARK: - HandleErrors

extension HomeSceneInteractor {
  private func handleErrors(_ error: Error) {
    switch error {
    default:
      break
    }
  }
}
// swiftlint: enable all
