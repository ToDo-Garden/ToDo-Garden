//
//  HomeSceneWorker.swift
//  HomeScene
//
//  Created by Noah on 1/9/25.
//  Copyright (c) 2025 ToDoGarden. All rights reserved.

import Foundation

import HomeSceneAPI
import HomeSceneEntity
import HTTPClientAPI
import TDFoundation
import TDFoundationExtension

public struct HomeSceneWorker: HomeSceneWorkable, Sendable {
  private let httpClient: HTTPClientAPI
  private let homeStorage: any JSONStorable<HomeScene.TodoBatchItem>
  
  public init(
    httpClient: HTTPClientAPI,
    homeStorage: some JSONStorable<HomeScene.TodoBatchItem>
  ) {
    self.httpClient = httpClient
    self.homeStorage = homeStorage
  }
  
  public func fetchToDoList() async throws -> [HomeScene.FetchToDoList.Response] {
    
    return self.makeMockList()
  }
  
  public func createToDo() async throws {
    
  }
  
  public func deleteToDo() async throws {
    
  }
}

// swiftlint:disable all
extension HomeSceneWorker {
  private func makeMockList() -> [HomeScene.FetchToDoList.Response] {
    let mockItems1 = [
      HomeScene.TodoListItem(
          name: "background Task 학습",
          endDay: nil,
          isDone: false,
          localID: "a523d5ae-b6ff-481e-98c9-11deb10eb7fb",
          startDay: nil,
          alarmTime: 72000,
          isAlarmOn: true,
          isOnlyToday: true,
          repeatToDoId: nil
      ),
      HomeScene.TodoListItem(
          name: "UIApplication 학습",
          endDay: nil,
          isDone: false,
          localID: "fdabd569-f835-4756-b3c2-46ab253ec69c",
          startDay: nil,
          alarmTime: 72000,
          isAlarmOn: true,
          isOnlyToday: true,
          repeatToDoId: nil
      ),
      HomeScene.TodoListItem(
          name: "SceneDelegate 학습",
          endDay: nil,
          isDone: false,
          localID: "a2fcec4d-50d5-4152-ac6a-e710bce4d47f",
          startDay: nil,
          alarmTime: 72000,
          isAlarmOn: true,
          isOnlyToday: true,
          repeatToDoId: nil
      ),
      HomeScene.TodoListItem(
          name: "Structured Concurrency WWDC 학습",
          endDay: nil,
          isDone: true,
          localID: "f80cdcfb-273f-4320-bbf3-b9faec859eab",
          startDay: nil,
          alarmTime: 72000,
          isAlarmOn: true,
          isOnlyToday: true,
          repeatToDoId: nil
      ),
      HomeScene.TodoListItem(
          name: "Diffable DataSource WWDC 학습",
          endDay: nil,
          isDone: true,
          localID: "de119513-b415-451c-825e-9ab94a03d10f",
          startDay: nil,
          alarmTime: 72000,
          isAlarmOn: true,
          isOnlyToday: true,
          repeatToDoId: nil
      )
  ]
    
    let mockItems2 = [
      HomeScene.TodoListItem(
          name: "View LifeCycle 학습",
          endDay: nil,
          isDone: false,
          localID: "e29e8791-0683-418c-8658-78ed2fdc981c",
          startDay: nil,
          alarmTime: 72000,
          isAlarmOn: true,
          isOnlyToday: true,
          repeatToDoId: nil
      ),
      HomeScene.TodoListItem(
          name: "Swift Testing 공부하기",
          endDay: nil,
          isDone: true,
          localID: "01a19311-5727-49fe-af20-89bd0a5af848",
          startDay: nil,
          alarmTime: 72000,
          isAlarmOn: true,
          isOnlyToday: true,
          repeatToDoId: nil
      )
  ]

    let mockData = HomeScene.FetchToDoList.Response(
      date: Date.now.toStringDateFormatWithDash(),
      list: [
        HomeScene.TodoListGroup(id: "6e75050a-1859-4781-88ef-b1ce3c2c3158", name: "그룹 1", color: "#FFC83C", todoList: nil, progressRate: 0.0),
        HomeScene.TodoListGroup(id: "c5e18427-2928-42ab-8cd0-f8695c63f173", name: "iOS", color: "#4563FF", todoList: mockItems1, progressRate: 0),
        HomeScene.TodoListGroup(id: "e89850f8-315f-46bd-96f4-713b38691d93", name: "그룹 2", color: "#FF6464", todoList: mockItems2, progressRate: 0)
      ]
    )
    
    return [mockData]
  }
}
// swiftlint:enable all
