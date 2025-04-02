//
//  HomeSceneWorkable.swift
//  HomeScene
//
//  Created by Noah on 1/9/25.
//  Copyright (c) 2025 ToDoGarden. All rights reserved.

import Foundation

import HomeSceneEntity
import SharedEntity
import TDFoundation

public protocol HomeSceneWorkable: Sendable {
  func fetchToDoList(dateString: String) async throws -> [DailyToDoListData]
  func writeBatchItemsToGRDB(data: [TodoBatchItem]) async throws
  func requestBatchUpdateToServer() async throws
  func loadMonthlyToDoListFromGRDB(dateString: String) async throws -> [DailyToDoListData]
  func syncronizeGRDBWithBatchItems() async throws
}
