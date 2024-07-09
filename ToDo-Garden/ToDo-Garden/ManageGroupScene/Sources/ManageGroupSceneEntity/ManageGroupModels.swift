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
    public struct Request {
      public init() { }
    }
    public struct Response {
      public init() { }
    }
    public struct ViewModel {
      public init() { }
    }
  }
}
