//
//  HomeSceneWorkable.swift
//  HomeScene
//
//  Created by Noah on 1/9/25.
//  Copyright (c) 2025 ToDoGarden. All rights reserved.

import Foundation

import HomeSceneEntity
<<<<<<< HEAD
import SharedEntity

public protocol HomeSceneWorkable: Sendable {
  func fetchToDoList(dateString: String) async throws -> [HomeScene.FetchToDoList.Response]
  func writeJSONFile(data: [SharedEntity.TodoBatchItem]) async throws
  func deleteToDo() async throws
=======
import TDFoundation

public protocol HomeSceneWorkable: Sendable {
  func fetchToDoList(dateString: String) async throws -> [DailyToDoListData]
  func writeBatchItemsToGRDB(data: [TodoBatchItem]) async throws
>>>>>>> fc930727 (#907: 변경사항 반영)
  func requestBatchUpdateToServer() async throws
  func loadMonthlyToDoListFromGRDB(dateString: String) async throws -> [DailyToDoListData]
  func syncronizeGRDBWithBatchItems() async throws
}
