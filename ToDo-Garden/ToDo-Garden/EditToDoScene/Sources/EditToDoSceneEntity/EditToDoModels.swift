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
      public struct FetchedToDo: Equatable {
        public let toDo: ToDo
        public let groupList: [Group]
        public let repetitionViewState: EditToDoRepetitionViewState

        public init(
          toDo: ToDo,
          groupList: [Group],
          repetitionViewState: EditToDoRepetitionViewState
        ) {
          self.toDo = toDo
          self.groupList = groupList
          self.repetitionViewState = repetitionViewState
        }
      }

      public let fetchResult: Result<FetchedToDo, Error>

      public init(fetchResult: Result<FetchedToDo, Error>) {
        self.fetchResult = fetchResult
      }
    }

    public struct ViewModel {
      public struct DisplayedToDo {
        public let toDoName: String
        public let group: Group
        public let groupList: [Group]
        public let isAlarmOn: Bool
        public let alarmTime: String?
        public let repetitionViewState: EditToDoRepetitionViewState
        public let startDay: String?
        public let endDay: String?

        public init(
          toDoName: String,
          group: Group,
          groupList: [Group],
          isAlarmOn: Bool,
          alarmTime: String?,
          repetitionViewState: EditToDoRepetitionViewState,
          startDay: String?,
          endDay: String?
        ) {
          self.toDoName = toDoName
          self.group = group
          self.groupList = groupList
          self.isAlarmOn = isAlarmOn
          self.alarmTime = alarmTime
          self.repetitionViewState = repetitionViewState
          self.startDay = startDay
          self.endDay = endDay
        }
      }

      public let fetchedToDoResult: Result<DisplayedToDo, Error>

      public init(fetchedToDoResult: Result<DisplayedToDo, Error>) {
        self.fetchedToDoResult = fetchedToDoResult
      }
    }
  }

  public enum CompleteEditToDo {
    public struct Request {
      public struct DisplayedGroup {
        public let id: Int
        public let name: String
        public let color: UIColor

        public init(id: Int, name: String, color: UIColor) {
          self.id = id
          self.name = name
          self.color = color
        }
      }

      public let toDoName: String
      public let displayedGroup: DisplayedGroup

      public init(toDoName: String, displayedGroup: DisplayedGroup) {
        self.toDoName = toDoName
        self.displayedGroup = displayedGroup
      }
    }

    public struct Response {
      public let editResult: Result<Void, Error>

      public init(editResult: Result<Void, Error>) {
        self.editResult = editResult
      }
    }

    public struct ViewModel {
      public let editResult: Result<Void, Error>

      public init(editResult: Result<Void, Error>) {
        self.editResult = editResult
      }
    }
  }

  public enum DeleteToDo {
    public struct Request {
      public init() {}
    }

    public struct Response {
      public let deleteResult: Result<Void, Error>

      public init(deleteResult: Result<Void, Error>) {
        self.deleteResult = deleteResult
      }
    }

    public struct ViewModel {
      public let deleteResult: Result<Void, Error>

      public init(deleteResult: Result<Void, Error>) {
        self.deleteResult = deleteResult
      }
    }
  }

  /// 사용자가 투두 알림 시간을 변경할 때, 기존에 선택했던 투두 알림 시간을 보여주는 유스케이스입니다.
  public enum FetchAlarmTime {
    public struct Response {
      public let alarmTime: Double?

      public init(alarmTime: Double?) {
        self.alarmTime = alarmTime
      }
    }

    public struct ViewModel {
      public let hour: Int
      public let minute: Int

      public init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
      }
    }
  }

  /// 사용자가 투두 알림 시간을 변경하는 유스케이스입니다.
  public enum ChangeAlarmTime {
    public struct Request {
      public let alarmTime: Double

      public init(alarmTime: Double) {
        self.alarmTime = alarmTime
      }
    }

    public struct Response {
      public let alarmTime: Double

      public init(alarmTime: Double) {
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
      public let startDate: Date
      public let endDate: Date

      public init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
      }
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

  /// 사용자가 투두 알림 여부를 스위치로 활성화 및 비활성화 시키는 유스케이스입니다.
  public enum ChangeAlarmActivation {
    public struct Request {
      public init() {}
    }

    public struct Response {
      public let isAlarmOn: Bool

      public init(isAlarmOn: Bool) {
        self.isAlarmOn = isAlarmOn
      }
    }

    public struct ViewModel {
      public let isAlarmOn: Bool

      public init(isAlarmOn: Bool) {
        self.isAlarmOn = isAlarmOn
      }
    }
  }
}

extension EditToDo {
  public struct ToDo: Equatable {
    public var name: String
    public var groupData: Group
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

    public static func == (lhs: EditToDo.ToDo, rhs: EditToDo.ToDo) -> Bool {
      return lhs.name == rhs.name
      && lhs.groupData.id == rhs.groupData.id
      && lhs.groupData.name == rhs.groupData.name
      && lhs.groupData.color == rhs.groupData.color
      && lhs.alarm.isAlarmOn == rhs.alarm.isAlarmOn
      && lhs.alarm.alarmTime == rhs.alarm.alarmTime
      && lhs.repetition.isOnlyToday == rhs.repetition.isOnlyToday
      && lhs.repetition.isRepeatEveryday == rhs.repetition.isRepeatEveryday
      && lhs.repetition.startDate == rhs.repetition.startDate
      && lhs.repetition.endDate == rhs.repetition.endDate
    }
  }

  public struct Group: Equatable {
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
    public var isAlarmOn: Bool
    public var alarmTime: Double?

    public init(isAlarmOn: Bool, alarmTime: Double?) {
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

  /// 투두 반복 설정 뷰의 상태를 나타내는 데이터입니다.
  public enum EditToDoRepetitionViewState {
    case repeatOnlyToday
    case repeatEveryday
    case repeatInRange
  }
}
