//
//  EditToDoWorker.swift
//  
//
//  Created by Wood on 6/29/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import EditToDoSceneAPI
import EditToDoSceneEntity

public struct EditToDoWorker: EditToDoWorkable {
  public func fetchToDo(id: UUID) async throws -> EditToDo.ToDo {
    <#code#>
  }
  
  public func fetchGroupList() async throws -> [EditToDo.Group] {
    <#code#>
  }
  
  public func editToDo(id: UUID) async throws {
    <#code#>
  }

  public func deleteToDo(id: UUID) async throws {
    <#code#>
  }
}
