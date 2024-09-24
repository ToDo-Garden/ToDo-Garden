//
//  PostGroupModels.swift
//
//
//  Created by SONG on 7/8/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit.UIColor

public enum PostGroup {
  public struct ToDoGroup: Sendable {
    public let groupID: UUID?
    public var groupName: String
    public var groupColor: UIColor
    
    public init(groupID: UUID?, groupName: String, groupColor: UIColor) {
      self.groupID = groupID
      self.groupName = groupName
      self.groupColor = groupColor
    }
  }
  
  // MARK: Use cases
  public enum ChangeColor {
    public struct Request {
      public let groupColor: UIColor
      
      public init(groupColor: UIColor) {
        self.groupColor = groupColor
      }
    }
    
    public struct Response {
      public let groupColor: UIColor
      
      public init(groupColor: UIColor) {
        self.groupColor = groupColor
      }
    }
    public struct ViewModel {
      public let groupColor: UIColor
      
      public init(groupColor: UIColor) {
        self.groupColor = groupColor
      }
    }
  }
  
  public enum LoadGroupData {
    
    public struct Response {
      public let groupName: String
      public let groupColor: UIColor?
      public let isDoneBottomButtonEnable: Bool
      
      public init(
        groupName: String,
        groupColor: UIColor?,
        isDoneBottomButtonEnable: Bool
      ) {
        self.groupName = groupName
        self.groupColor = groupColor
        self.isDoneBottomButtonEnable = isDoneBottomButtonEnable
      }
    }
    
    public struct ViewModel {
      public let sceneTitle: String
      public let groupName: String
      public let groupColor: UIColor?
      public let isDoneBottomButtonEnable: Bool
      
      public init(
        sceneTitle: String,
        groupName: String,
        groupColor: UIColor?,
        isDoneBottomButtonEnable: Bool
      ) {
        self.sceneTitle = sceneTitle
        self.groupName = groupName
        self.groupColor = groupColor
        self.isDoneBottomButtonEnable = isDoneBottomButtonEnable
      }
    }
  }
  
  public enum TouchDoneButton {
    public struct Request {
      public let groupName: String
      public let groupColor: UIColor
      
      public init(groupName: String, groupColor: UIColor) {
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
      
      public init() {
      }
    }
  }
}
