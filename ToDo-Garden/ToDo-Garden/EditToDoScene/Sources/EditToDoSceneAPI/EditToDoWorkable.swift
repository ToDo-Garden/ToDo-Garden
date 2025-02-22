//
//  EditToDoWorkable.swift
//  
//
//  Created by Wood on 6/29/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import EditToDoSceneEntity

public protocol EditToDoWorkable {
  func fetchToDo(id: UUID) async throws -> EditToDo.ToDo
  func fetchGroupList() async throws -> [EditToDo.Group]
  func editToDo(id: UUID) async throws
  func deleteToDo(id: UUID) async throws
}
