//
//  HomeSceneModels.swift
//  HomeScene
//
//  Created by Noah on 1/9/25.
//  Copyright (c) 2025 ToDoGarden. All rights reserved.

import Foundation

// swiftlint:disable all
public enum HomeScene {
  // MARK: Use cases
  public enum FetchToDoList {    
    public struct Response: Codable, Sendable {
      public let date: String
      public let list: [TodoListGroup]
      
      public init(date: String, list: [TodoListGroup]) {
        self.date = date
        self.list = list
      }
    }
    
    public struct ViewModel {
      
      public init() {
      }
    }
  }
  
  public enum BatchUpdate {
    public struct TodoBatchRequest: Codable, Sendable {
      public let data: [TodoBatchItem]
    }

  }
}

// MARK: DTO
extension HomeScene {
  public struct TodoListGroup: Codable, Sendable {
    public let id: String
    public let name: String
    public let color: String
    public let todoList: [TodoListItem]?
    public let progressRate: Double
    
    public init(id: String, name: String, color: String, todoList: [TodoListItem]?, progressRate: Double) {
      self.id = id
      self.name = name
      self.color = color
      self.todoList = todoList
      self.progressRate = progressRate
    }
  }
  
  public struct TodoListItem: Codable, Sendable {
    public let name: String
    public let endDay: String?
    public let isDone: Bool
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
  
  public struct TodoBatchItem: Codable, Sendable {
    public let localId: String
    public let name: String
    public let isDone: Bool
    public let createdAt: String 
    public let isAlarmOn: Bool
    public let alarmTime: Double
    public let isOnlyToday: Bool
    public let startDay: String?
    public let endDay: String?
    public let groupId: String
    public let isDelete: Bool
    
    public init(localId: String, name: String, isDone: Bool, createdAt: String, isAlarmOn: Bool, alarmTime: Double, isOnlyToday: Bool, startDay: String?, endDay: String?, groupId: String, isDelete: Bool) {
      self.localId = localId
      self.name = name
      self.isDone = isDone
      self.createdAt = createdAt
      self.isAlarmOn = isAlarmOn
      self.alarmTime = alarmTime
      self.isOnlyToday = isOnlyToday
      self.startDay = startDay
      self.endDay = endDay
      self.groupId = groupId
      self.isDelete = isDelete
    }
  }
}
// swiftlint:enable all
