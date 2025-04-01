//
//  HomeSceneModels.swift
//  HomeScene
//
//  Created by Noah on 1/9/25.
//  Copyright (c) 2025 ToDoGarden. All rights reserved.

import Foundation

import SharedEntity

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
    
    public struct Response: Codable, Sendable {
      public let date: String
      public let list: [SharedEntity.TodoListGroup]

      public init(date: String, list: [SharedEntity.TodoListGroup]) {
        self.date = date
        self.list = list
      }
    }
  }
  
  public enum BatchUpdate {
    public struct TodoBatchRequest: Codable, Sendable {
      public let data: [SharedEntity.TodoBatchItem]

      public init(data: [TodoBatchItem]) {
        self.data = data
      }
    }
  }
}
// swiftlint:enable all
