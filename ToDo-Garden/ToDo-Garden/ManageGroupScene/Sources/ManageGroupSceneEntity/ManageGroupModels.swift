//
//  ManageGroupModels.swift
//
//
//  Created by SONG on 6/26/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit.UIColor

public enum ManageGroup {
  public struct ToDoGroup {
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
  }
  // MARK: Use cases
  
  public enum FetchGroupList {
    public struct Request {
      let userInfo: String
      
      public init() {
        self.userInfo = "something"
      }
    }
    
    public struct Response {
      let data: String
      public init(with data: String) {
        self.data = data
      }
    }
    
    public struct ViewModel {
      public var list: [ToDoGroup]
      public init(with list: [ToDoGroup]) {
        self.list = list
      }
    }
  }
  
  public enum DeleteGroup {
    public struct Request {
      public let userInfo: String
      public let id: String
      public let index: Int
      
      public init(id: String, index: Int) {
        self.userInfo = "something"
        self.id = id
        self.index = index
      }
    }
    
    public struct Response {
      public let data: String
      public let id: String
      public let index: Int
      
      public init(id: String, index: Int) {
        self.data = "something"
        self.id = id
        self.index = index
      }
    }
    
    public struct ViewModel {
      public let isDeleted: Bool
      public let id: String
      public let index: Int
      
      public init(
        isDeleted: Bool,
        id: String,
        index: Int
      ) {
        self.isDeleted = isDeleted
        self.id = id
        self.index = index
      }
    }
  }
  
  public enum ReorderGroup {
    public struct Request {
      let userInfo: String
      public var reorderedGroups: [ReorderedGroup]
      
      public init() {
        self.userInfo = "something"
        self.reorderedGroups = []
      }
    }
    
    public struct Response {
      public let data: Bool
      public init(with data: Bool) {
        self.data = data
      }
    }
    
    public struct ViewModel {
      public var data: Bool
      public init(with data: Bool) {
        self.data = data
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
