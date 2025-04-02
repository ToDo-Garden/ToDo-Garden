//
//  HomeSceneModels.swift
//  HomeScene
//
//  Created by Noah on 1/9/25.
//  Copyright (c) 2025 ToDoGarden. All rights reserved.

import Foundation

import SharedEntity
import TDFoundation

// swiftlint:disable all
public enum HomeScene {
  // MARK: Use cases
  public enum FetchToDoList {
    public struct Request: Sendable {
      public let dateString: String
      public init(dateString: String) {
        self.dateString = dateString
      }
    }
  }
  
  public enum BatchUpdate {
    public struct TodoBatchRequest: Codable, Sendable {
      public let data: [TodoBatchItem]

      public init(data: [TodoBatchItem]) {
        self.data = data
      }
    }
  }

  public enum PrepareDataForEditToDoScene {
    public struct Request: Sendable {
      public let todoId: UUID
      public let selectedDate: Date
      public let groupId: UUID

      public init(todoId: UUID, selectedDate: Date, groupId: UUID) {
        self.todoId = todoId
        self.selectedDate = selectedDate
        self.groupId = groupId
      }
    }
  }
}
// swiftlint:enable all
