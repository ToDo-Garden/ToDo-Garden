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

public struct HomeSceneWorker: HomeSceneWorkable, Sendable {
  private let httpClient: HTTPClientAPI
  
  public init(httpClient: HTTPClientAPI) {
    self.httpClient = httpClient
  }
  
  public func fetchToDoList() async throws -> HomeScene.FetchToDoList.Response {
    
    return self.makeMockList()
  }
  
  public func createToDo() async throws {
    
  }
  
  public func deleteToDo() async throws {
    
  }
}

// swiftlint:disable all
extension HomeSceneWorker {
  private func makeMockList() -> HomeScene.FetchToDoList.Response {
    let mockData = HomeScene.FetchToDoList.Response(
      groups: [
        HomeScene.Group(id: "6e75050a-1859-4781-88ef-b1ce3c2c3158", name: "그룹 1", color: "#FFC83C", todoList: nil, progressRate: 0),
        HomeScene.Group(id: "c5e18427-2928-42ab-8cd0-f8695c63f173", name: "iOS", color: "#4563FF", todoList: nil, progressRate: 0),
        HomeScene.Group(id: "e89850f8-315f-46bd-96f4-713b38691d93", name: "그룹 2", color: "#FF6464", todoList: nil, progressRate: 0)
      ],
      list: [
        HomeScene.DailyTodoList(
          date: Date.now.toStringDateFormat(),
          list: [
            HomeScene.Group(
              id: "6e75050a-1859-4781-88ef-b1ce3c2c3158",
              name: "그룹 1",
              color: "#FFC83C",
              todoList: nil,
              progressRate: 0
            ),
            HomeScene.Group(
              id: "c5e18427-2928-42ab-8cd0-f8695c63f173",
              name: "iOS",
              color: "#4563FF",
              todoList: [
                HomeScene.Todo(id: "a523d5ae-b6ff-481e-98c9-11deb10eb7fb", name: "background Task 학습", isDone: false, orderIdx: 0, isAlarmOn: true),
                HomeScene.Todo(id: "fdabd569-f835-4756-b3c2-46ab253ec69c", name: "UIApplication 학습", isDone: false, orderIdx: 1, isAlarmOn: true),
                HomeScene.Todo(id: "a2fcec4d-50d5-4152-ac6a-e710bce4d47f", name: "SceneDelegate 학습", isDone: false, orderIdx: 2, isAlarmOn: true),
                HomeScene.Todo(id: "f80cdcfb-273f-4320-bbf3-b9faec859eab", name: "Structured Concurrency WWDC 학습", isDone: true, orderIdx: 3, isAlarmOn: true),
                HomeScene.Todo(id: "de119513-b415-451c-825e-9ab94a03d10f", name: "Diffable DataSource WWDC 학습", isDone: true, orderIdx: 4, isAlarmOn: true)
              ],
              progressRate: 0.4
            ),
            HomeScene.Group(
              id: "e89850f8-315f-46bd-96f4-713b38691d93",
              name: "그룹 2",
              color: "#FF6464",
              todoList: [
                HomeScene.Todo(id: "e29e8791-0683-418c-8658-78ed2fdc981c", name: "View LifeCycle 학습", isDone: false, orderIdx: 0, isAlarmOn: true),
                HomeScene.Todo(id: "01a19311-5727-49fe-af20-89bd0a5af848", name: "Swift Testing 공부하기", isDone: true, orderIdx: 1, isAlarmOn: true)
              ],
              progressRate: 0.5
            ),
            HomeScene.Group(
              id: "d7591884-f6be-454a-9372-fd157bb091ab",
              name: "수학",
              color: "#946E26",
              todoList: nil,
              progressRate: 0
            )
          ]
        )
      ]
    )
    
    return mockData
  }
}

extension Date {
  func toStringDateFormat() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    return dateFormatter.string(from: self)
  }
}
// swiftlint:enable all
