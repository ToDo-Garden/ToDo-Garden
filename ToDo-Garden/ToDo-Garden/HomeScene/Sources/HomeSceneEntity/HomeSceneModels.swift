//
//  HomeSceneModels.swift
//  HomeScene
//
//  Created by Noah on 1/9/25.
//  Copyright (c) 2025 ToDoGarden. All rights reserved.

import Foundation

public enum HomeScene {
  // MARK: Use cases
  public enum FetchToDoList {
    public struct Request {
      
      public init() {
      }
    }
    
    public struct Response: Codable, Sendable {
      public let groups: [Group]?
      public let list: [DailyTodoList]?
      
      public init(groups: [Group]?, list: [DailyTodoList]?) {
        self.groups = groups
        self.list = list
      }
    }
    
    public struct ViewModel {
      
      public init() {
      }
    }
  }
  
}

// MARK: DTO
extension HomeScene {
  public struct Todo: Codable, Sendable {
    public let id: String
    public let name: String
    public let isDone: Bool
    public let orderIdx: Int
    public let isAlarmOn: Bool
    
    public init(id: String, name: String, isDone: Bool, orderIdx: Int, isAlarmOn: Bool) {
      self.id = id
      self.name = name
      self.isDone = isDone
      self.orderIdx = orderIdx
      self.isAlarmOn = isAlarmOn
    }
  }

  // 그룹
  public struct Group: Codable, Sendable {
    public let id: String
    public let name: String
    public let color: String
    public let todoList: [Todo]?
    public let progressRate: Float
    
    public init(id: String, name: String, color: String, todoList: [Todo]?, progressRate: Float) {
      self.id = id
      self.name = name
      self.color = color
      self.todoList = todoList
      self.progressRate = progressRate
    }
  }

  // 특정 날짜에 해당하는 일정 목록
  public struct DailyTodoList: Codable, Sendable {
    public let date: String
    public let list: [Group]
    
    public init(date: String, list: [Group]) {
      self.date = date
      self.list = list
    }
  }
}
