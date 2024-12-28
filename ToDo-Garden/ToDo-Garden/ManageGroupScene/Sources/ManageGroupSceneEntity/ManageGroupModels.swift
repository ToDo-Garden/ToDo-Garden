//
//  ManageGroupModels.swift
//
//
//  Created by SONG on 6/26/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit.UIColor

public enum ManageGroup {
  public struct ToDoGroup: Equatable {
    public var groupID: UUID
    public let groupName: String
    public let progressColor: UIColor
    public let progressRate: Float
    
    public init(groupID: UUID = UUID(), groupName: String, progressColor: UIColor, progressRate: Float) {
      self.groupID = groupID
      self.groupName = groupName
      self.progressColor = progressColor
      self.progressRate = progressRate
    }
    
    public static func == (lhs: ToDoGroup, rhs: ToDoGroup) -> Bool {
      return lhs.groupID == rhs.groupID &&
      lhs.groupName == rhs.groupName &&
      lhs.progressColor == rhs.progressColor &&
      lhs.progressRate == rhs.progressRate
    }
  }
  // MARK: Use cases
  
  public enum FetchGroupList {
    public struct Request {
      public init() { }
    }
    
    public struct Response {
      public let data: [ToDoGroup]
      public init(with data: [ToDoGroup]) {
        self.data = data
      }
    }
    
    public struct ViewModel {
      public let list: [ToDoGroup]
      public init(with list: [ToDoGroup]) {
        self.list = list
      }
    }
  }
  
  public enum SaveGroupList {
    public struct Request {
      public let list: [ToDoGroup]
      public init(with list: [ToDoGroup]) {
        self.list = list
      }
    }
    
    public struct Response {
      public let data: [ToDoGroup]
      public init(with data: [ToDoGroup]) {
        self.data = data
      }
    }
    
    public struct ViewModel {
      public let list: [ToDoGroup]
      public init(with list: [ToDoGroup]) {
        self.list = list
      }
    }
  }
  
  public enum DeleteGroup {
    public struct Request {
      public let groupID: UUID
      public let index: Int
      
      public init(groupID: UUID, index: Int) {
        self.groupID = groupID
        self.index = index
      }
    }
    
    public struct Response {
      public let groupID: UUID
      public let index: Int
      
      public init(groupID: UUID, index: Int) {
        self.groupID = groupID
        self.index = index
      }
    }
    
    public struct ViewModel {
      public let groupID: UUID
      public let index: Int
      
      public init(
        groupID: UUID,
        index: Int
      ) {
        self.groupID = groupID
        self.index = index
      }
    }
  }
  
  public enum AddGroup {
    public struct Request {
      public let groupID: UUID
      public let groupName: String
      public let groupColor: UIColor
      
      public init(groupID: UUID, groupName: String, groupColor: UIColor) {
        self.groupID = groupID
        self.groupName = groupName
        self.groupColor = groupColor
      }
    }
    
    public struct Response {
      public let group: ToDoGroup
      
      public init(group: ToDoGroup) {
        self.group = group
      }
    }
    
    public struct ViewModel {
      public let group: ToDoGroup
      
      public init(group: ToDoGroup) {
        self.group = group
      }
    }
  }
  
  public enum EditGroup {
    public struct Request {
      public let groupID: UUID
      public let groupName: String
      public let groupColor: UIColor
      
      public init(groupID: UUID, groupName: String, groupColor: UIColor) {
        self.groupID = groupID
        self.groupName = groupName
        self.groupColor = groupColor
      }
    }
    
    public struct Response {
      public let group: ToDoGroup
      public let editedIndex: Int
      
      public init(group: ToDoGroup, editedIndex: Int) {
        self.group = group
        self.editedIndex = editedIndex
      }
    }
    
    public struct ViewModel {
      public let group: ToDoGroup
      public let editedIndex: Int
      
      public init(group: ToDoGroup, editedIndex: Int) {
        self.group = group
        self.editedIndex = editedIndex
      }
    }
  }
}

extension ManageGroup.FetchGroupList {
  public struct RequestDTO: Sendable, Codable {
    public init() { }
  }
  
  public struct ResponseDTO: Sendable, Codable {
    public let data: [GroupDataDTO]
    public let isMoreGroupExist: Bool
    
    public struct GroupDataDTO: Sendable, Codable {
      public let id: String
      public let name: String
      public let color: String
      public let progressrate: Int
      public let orderIdx: Int
      
      private enum CodingKeys: String, CodingKey {
        case id
        case name
        case color
        case progressrate
        case orderIdx = "order_idx"
      }
    }
  }
}

extension ManageGroup.AddGroup {
  public struct RequestDTO: Sendable, Codable {
    public let name: String
    public let color: String
    
    public init(name: String, color: String) {
      self.name = name
      self.color = color
    }
  }
}

extension ManageGroup.EditGroup {
  public struct RequestDTO: Sendable, Codable {
    public let name: String
    public let color: String
    
    public init(name: String, color: String) {
      self.name = name
      self.color = color
    }
  }
}

extension ManageGroup {
  public enum TaskType: Sendable {
    case add
    case remove
    case edit
    case reorder
  }
  
  public struct PendingItem: Sendable {
    public let taskType: TaskType
    public let groupID: UUID?
    public let requestDTO: Sendable?
    
    public init(taskType: TaskType, groupID: UUID?, requestDTO: Sendable) {
      self.taskType = taskType
      self.groupID = groupID
      self.requestDTO = requestDTO
    }
  }
}
