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
  
  public enum Something {
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
