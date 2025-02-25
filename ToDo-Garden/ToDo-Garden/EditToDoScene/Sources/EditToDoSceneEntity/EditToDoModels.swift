//
//  EditToDoModels.swift
//
//
//  Created by Wood on 6/29/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit.UIColor

// swiftlint:disable file_length
public enum EditToDo {
  // MARK: Use cases
  public enum FetchToDo {
    public struct Request {
      public init() {}
    }

    public struct Response {
      public let toDo: ToDo

      public init(toDo: ToDo) {
        self.toDo = toDo
      }
    }

    public struct ViewModel {
      public struct DisplayedToDo {
        public let toDoName: String
        public let group: DisplayedGroup
        public let isAlarmOn: Bool
        public let alarmTime: String?
        public let isOnlyToday: Bool
        public let startDay: String?
        public let endDay: String?

        public init(
          toDoName: String,
          group: DisplayedGroup,
          isAlarmOn: Bool,
          alarmTime: String?,
          isOnlyToday: Bool,
          startDay: String?,
          endDay: String?
        ) {
          self.toDoName = toDoName
          self.group = group
          self.isAlarmOn = isAlarmOn
          self.alarmTime = alarmTime
          self.isOnlyToday = isOnlyToday
          self.startDay = startDay
          self.endDay = endDay
        }
      }

      public let toDo: DisplayedToDo

      public init(toDo: DisplayedToDo) {
        self.toDo = toDo
      }
    }
  }

  public enum FetchGroupList {}

  public enum CompleteEditToDo {
    public struct Request {
      public let toDoName: String
      public let displayedGroup: DisplayedGroup

      public init(toDoName: String, displayedGroup: DisplayedGroup) {
        self.toDoName = toDoName
        self.displayedGroup = displayedGroup
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
      && lhs.repetition.startDate == rhs.repetition.startDate
      && lhs.repetition.endDate == rhs.repetition.endDate
    }
  }

  public struct Group: Equatable {
    public let id: UUID
    public let name: String
    public let color: String
    public let orderIdx: Int

    public init(
      id: UUID,
      name: String,
      color: String,
      orderIdx: Int
    ) {
      self.id = id
      self.name = name
      self.color = color
      self.orderIdx = orderIdx
    }
  }

  public struct DisplayedGroup {
    public let id: UUID
    public let name: String
    public let color: UIColor
    public let orderIdx: Int

    public init(
      id: UUID, 
      name: String,
      color: UIColor,
      orderIdx: Int
    ) {
      self.id = id
      self.name = name
      self.color = color
      self.orderIdx = orderIdx
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
    public var startDate: Date?
    public var endDate: Date?

    public init(
      isOnlyToday: Bool,
      startDate: Date? = nil,
      endDate: Date? = nil
    ) {
      self.isOnlyToday = isOnlyToday
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

// MARK: DTO Objects

extension EditToDo {
  public struct GroupDTO: Sendable, Codable {
    public let id: UUID
    public let name: String
    public let color: String
    public let orderIdx: Int

    public init(
      id: UUID,
      name: String, 
      color: String,
      orderIdx: Int
    ) {
      self.id = id
      self.name = name
      self.color = color
      self.orderIdx = orderIdx
    }
  }
}

extension EditToDo.FetchToDo {
  public struct RequestDTO: Sendable, Codable {
    public let id: UUID

    public init(id: UUID) {
      self.id = id
    }
  }

  public struct ResponseDTO: Sendable, Codable {
    public let name: String
    public let group: EditToDo.GroupDTO
    public let isAlarmOn: Bool
    public let alarmTime: Double
    public let isOnlyToday: Bool
    public let startDate: Date?
    public let endDate: Date?
  }
}

extension EditToDo.FetchGroupList {
  public struct RequestDTO: Sendable, Codable {
    public init() {}
  }

  public struct ResponseDTO: Sendable, Codable {
    public let data: [EditToDo.GroupDTO]
    public let isMoreGroupExist: Bool
  }
}

extension EditToDo.CompleteEditToDo {
  public struct RequestDTO: Sendable, Codable {
    public let name: String
    public let isAlarmOn: Bool
    public let alarmTime: Double?
    public let isOnlyToday: Bool
    public let startDay: Date?
    public let endDay: Date?
    public let groupId: UUID

    private enum CodingKeys: String, CodingKey {
      case name
      case isAlarmOn = "is_alarm_on"
      case alarmTime = "alarm_time"
      case isOnlyToday = "is_only_today"
      case startDay = "start_day"
      case endDay = "end_day"
      case groupId = "group_id"
    }

    public init(
      name: String,
      isAlarmOn: Bool,
      alarmTime: Double? = nil,
      isOnlyToday: Bool,
      startDay: Date? = nil,
      endDay: Date? = nil,
      groupId: UUID
    ) {
      self.name = name
      self.isAlarmOn = isAlarmOn
      self.alarmTime = alarmTime
      self.isOnlyToday = isOnlyToday
      self.startDay = startDay
      self.endDay = endDay
      self.groupId = groupId
    }
  }
}

extension EditToDo.DeleteToDo {
  public struct RequestDTO: Sendable, Codable {
    public let todoId: String

    private enum CodingKeys: String, CodingKey {
      case todoId = "todo_id"
    }

    public init(todoId: String) {
      self.todoId = todoId
    }
  }
}

extension EditToDo {
  public enum ErrorType: String {
    case temporary = "잠시 후\n다시 시도해주세요!"
    case network = "네트워크 연결이\n불안정합니다"
    case failToFetch
  }
}
// swiftlint:enable file_length
