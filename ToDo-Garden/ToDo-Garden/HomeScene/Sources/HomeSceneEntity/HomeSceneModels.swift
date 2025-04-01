//
//  HomeSceneModels.swift
//  HomeScene
//
//  Created by Noah on 1/9/25.
//  Copyright (c) 2025 ToDoGarden. All rights reserved.

import Foundation

<<<<<<< HEAD
import SharedEntity
=======
import TDFoundation
>>>>>>> fc930727 (#907: 변경사항 반영)

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
<<<<<<< HEAD
    
    public struct Response: Codable, Sendable {
      public let date: String
      public let list: [SharedEntity.TodoListGroup]

      public init(date: String, list: [SharedEntity.TodoListGroup]) {
        self.date = date
        self.list = list
      }
    }
=======
>>>>>>> fc930727 (#907: 변경사항 반영)
  }
  
  public enum BatchUpdate {
    public struct TodoBatchRequest: Codable, Sendable {
      public let data: [SharedEntity.TodoBatchItem]

      public init(data: [TodoBatchItem]) {
        self.data = data
      }
    }
  }

<<<<<<< HEAD
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
=======
>>>>>>> fc930727 (#907: 변경사항 반영)
// swiftlint:enable all
