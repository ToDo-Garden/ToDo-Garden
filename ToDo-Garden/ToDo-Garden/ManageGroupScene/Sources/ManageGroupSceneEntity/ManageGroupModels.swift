//
//  ManageGroupModels.swift
//
//
//  Created by SONG on 6/26/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit.UIColor

public enum ManageGroup {
  public struct ToDoGroup: Equatable {
    public let id: String
    public let groupName: String
    public let progressColor: UIColor
    public let progressRate: Float
    
    public init(id: String, groupName: String, progressColor: UIColor, progressRate: Float) {
      self.id = id
      self.groupName = groupName
      self.progressColor = progressColor
      self.progressRate = progressRate
    }
    
    public static func == (lhs: ToDoGroup, rhs: ToDoGroup) -> Bool {
      return lhs.id == rhs.id &&
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
      public let id: String
      public let index: Int
      
      public init(id: String, index: Int) {
        self.id = id
        self.index = index
      }
    }
    
    public struct Response {
      public let id: String
      public let index: Int
      
      public init(id: String, index: Int) {
        self.id = id
        self.index = index
      }
    }
    
    public struct ViewModel {
      public let id: String
      public let index: Int
      
      public init(
        id: String,
        index: Int
      ) {
        self.id = id
        self.index = index
      }
    }
  }
}

extension ManageGroup {
  public struct ReorderedGroup {
    let id: String
    let sourceIndex: Int
    let destinationIndex: Int
    
    public init(id: String, sourceIndex: Int, destinationIndex: Int) {
      self.id = id
      self.sourceIndex = sourceIndex
      self.destinationIndex = destinationIndex
    }
  }
}
