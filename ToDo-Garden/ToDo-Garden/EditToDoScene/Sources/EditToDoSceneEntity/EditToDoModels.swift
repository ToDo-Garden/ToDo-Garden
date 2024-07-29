//
//  EditToDoModels.swift
//
//
//  Created by Wood on 6/29/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit.UIColor

public enum EditToDo {
  // MARK: Use cases
  public enum FetchToDo {
    public struct Request {
      public init() {}
    }

    public struct Response {
      public let toDo: ToDo
      public let groupList: [Group]

      public init(toDo: ToDo, groupList: [Group]) {
        self.toDo = toDo
        self.groupList = groupList
      }
    }

    public struct ViewModel {
      public let toDoName: String
      public let group: Group
      public let groupList: [Group]
      public let isAlarmOn: Bool
      public let alarmTime: String?
      public let isRepeatOnlyToday: Bool
      public let startDay: String?
      public let endDay: String?

      public init(
        toDoName: String,
        group: Group,
        groupList: [Group],
        isAlarmOn: Bool,
        alarmTime: String?,
        isRepeatOnlyToday: Bool,
        startDay: String?,
        endDay: String?
      ) {
        self.toDoName = toDoName
        self.group = group
        self.groupList = groupList
        self.isAlarmOn = isAlarmOn
        self.alarmTime = alarmTime
        self.isRepeatOnlyToday = isRepeatOnlyToday
        self.startDay = startDay
        self.endDay = endDay
      }
    }
  }
  
  public enum CompleteEditToDo {
    public struct ToDoEditData {
      public let name: String
      public let groupId: Int

      public init(name: String, groupId: Int) {
        self.name = name
        self.groupId = groupId
      }
    }

    public struct ToDoScheduleData {
      public let isAlarmOn: Bool
      public let isRepeatOnlyToday: Bool

      public init(isAlarmOn: Bool, isRepeatOnlyToday: Bool) {
        self.isAlarmOn = isAlarmOn
        self.isRepeatOnlyToday = isRepeatOnlyToday
      }
    }

    public struct Request {
      public let toDoEditData: ToDoEditData
      public let toDoScheduleData: ToDoScheduleData

      public init(toDoEditData: ToDoEditData, toDoScheduleData: ToDoScheduleData) {
        self.toDoEditData = toDoEditData
        self.toDoScheduleData = toDoScheduleData
      }
    }

    public struct Response {
      public let editResult: Result<Bool, Error>
    }

    public struct ViewModel {
      public let editResult: Result<Bool, Error>

      public init(editResult: Result<Bool, Error>) {
        self.editResult = editResult
      }
    }
  }

  public enum DeleteToDo {
    public struct Request {
      public init() {}
    }

    public struct Response {
      public let deleteResult: Result<Bool, Error>

      public init(deleteResult: Result<Bool, Error>) {
        self.deleteResult = deleteResult
      }
    }

    public struct ViewModel {
      public let deleteResult: Result<Bool, Error>

      public init(deleteResult: Result<Bool, Error>) {
        self.deleteResult = deleteResult
      }
    }
  }

  public enum ChangeAlarmTime {
    public struct Request {
      public let alarmTime: Double

      public init(alarmTime: Double) {
        self.alarmTime = alarmTime
      }
    }

    public struct Response {
      public let alarmTime: Date?

      public init(alarmTime: Date?) {
        self.alarmTime = alarmTime
      }
    }

    public struct ViewModel {
      public let alarmTimeString: String

      public init(alarmTimeString: String) {
        self.alarmTimeString = alarmTimeString
      }
    }
  }

  public enum ChangeRepetitionRange {
    public struct Request {
      public init() {}
    }

    public struct Response {
      public let startDate: Date
      public let endDate: Date

      public init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
      }
    }

    public struct ViewModel {
      public let startDay: String
      public let endDay: String

      public init(startDay: String, endDay: String) {
        self.startDay = startDay
        self.endDay = endDay
      }
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
    public var alarmTime: Int?

    public init(isAlarmOn: Bool, alarmTime: Int?) {
      self.isAlarmOn = isAlarmOn
      self.alarmTime = alarmTime
    }
  }

  public struct ToDoRepetition {
    public var isOnlyToday: Bool
    public var isRepeatEveryday: Bool
    public var startDate: Date?
    public var endDate: Date?

    public init(
      isOnlyToday: Bool,
      isRepeatEveryday: Bool,
      startDate: Date? = nil,
      endDate: Date? = nil
    ) {
      self.isOnlyToday = isOnlyToday
      self.isRepeatEveryday = isRepeatEveryday
      self.startDate = startDate
      self.endDate = endDate
    }
  }
}

extension EditToDo {
  /// 컴파일 에러 방지용 코드로, Scene이 완성된 이후에 삭제할 예정입니다.
  public enum Something {
    public struct Request {
      public init() {}
    }
    public struct Response {
      public init() {}
    }
    public struct ViewModel {
      public init() {}
    }
  }
}
