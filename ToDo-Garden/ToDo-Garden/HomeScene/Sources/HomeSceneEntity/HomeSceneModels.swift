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
      public let list: [TodoListGroup]
      
      public init(date: String, list: [TodoListGroup]) {
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

// MARK: DTO
extension HomeScene {
  public final class TodoListGroup: Codable, @unchecked Sendable {
    public let localId: String
    public let name: String
    public let color: String
    public var todoList: [TodoListItem]?
    public let progressRate: Double
    
    public init(localId: String, name: String, color: String, todoList: [TodoListItem]?, progressRate: Double) {
      self.localId = localId
      self.name = name
      self.color = color
      self.todoList = todoList
      self.progressRate = progressRate
    }
  }
  
  public final class TodoListItem: Codable, @unchecked Sendable {
    public var name: String
    public let endDay: String?
    public var isDone: Bool
    public let localID: String
    public let startDay: String?
    public let alarmTime: Int?
    public let isAlarmOn: Bool
    public let isOnlyToday: Bool
    public let repeatToDoId: String?
    
    enum CodingKeys: String, CodingKey {
      case name, endDay, isDone, startDay, alarmTime, isAlarmOn, isOnlyToday, repeatToDoId
      case localID = "local_id"
    }
    
    public init(name: String, endDay: String?, isDone: Bool, localID: String, startDay: String?, alarmTime: Int?, isAlarmOn: Bool, isOnlyToday: Bool, repeatToDoId: String?) {
      self.name = name
      self.endDay = endDay
      self.isDone = isDone
      self.localID = localID
      self.startDay = startDay
      self.alarmTime = alarmTime
      self.isAlarmOn = isAlarmOn
      self.isOnlyToday = isOnlyToday
      self.repeatToDoId = repeatToDoId
    }
  }
}
// swiftlint:enable all
