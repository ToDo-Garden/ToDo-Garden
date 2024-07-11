//
//  EditToDoModels.swift
//
//
//  Created by Wood on 6/29/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit.UIColor

public enum EditToDo {
  
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

extension EditToDo {
  public struct ToDo {
    public let name: String
    public let groupData: Group
    public var alarm: ToDoAlarm
    public var repetition: ToDoRepetition

    public init(
      name: String,
      groupData: Group,
      alarm: ToDoAlarm,
      repetition: ToDoRepetition
    ) {
      self.name = name
      self.groupData = groupData
      self.alarm = alarm
      self.repetition = repetition
    }
  }

  public struct Group {
    public let id: Int
    public let name: String
    public let color: UIColor

    public init(id: Int, name: String, color: UIColor) {
      self.id = id
      self.name = name
      self.color = color
    }
  }

  public struct ToDoAlarm {
    public let isAlarmOn: Bool
    public var alarmTime: Date?

    public init(isAlarmOn: Bool, alarmTime: Date?) {
      self.isAlarmOn = isAlarmOn
      self.alarmTime = alarmTime
    }
  }

  public struct ToDoRepetition {
    public var isOnlyToday: Bool
    public var startDate: Date?
    public var endDate: Date?

    public init(isOnlyToday: Bool, startDate: Date?, endDate: Date?) {
      self.isOnlyToday = isOnlyToday
      self.startDate = startDate
      self.endDate = endDate
    }
  }
}
