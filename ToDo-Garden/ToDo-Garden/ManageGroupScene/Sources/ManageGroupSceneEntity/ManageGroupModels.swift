//
//  ManageGroupModels.swift
//
//
//  Created by SONG on 6/26/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit.UIColor

public enum ManageGroup {
  public struct ToDoGroup: Equatable {
    public let groupID: UUID
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
}
