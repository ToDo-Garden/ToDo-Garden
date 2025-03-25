//
//  HomeSceneWorkable.swift
//  HomeScene
//
//  Created by Noah on 1/9/25.
//  Copyright (c) 2025 ToDoGarden. All rights reserved.

import Foundation

import HomeSceneEntity

public protocol HomeSceneWorkable: Sendable {
  func fetchToDoList(dateString: String) async throws -> [HomeScene.FetchToDoList.Response]
  func createToDo() async throws
  func deleteToDo() async throws
}
