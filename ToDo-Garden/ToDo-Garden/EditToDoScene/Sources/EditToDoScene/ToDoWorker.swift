//
//  MockToDoWorker.swift
//
//
//  Created by Wood on 7/27/24.
//

import UIKit.UIColor

import EditToDoSceneEntity

public protocol ToDoWorkLogic {
  func fetchToDo(id: Int?) throws -> EditToDo.ToDo
  func deleteToDo(id: Int?) throws
  func editToDo(_ toDo: EditToDo.ToDo) throws
}

/// ToDo Context를 가정한 Mock Worker 입니다.
public final class ToDoWorker: ToDoWorkLogic {
  public init() {}

  public func fetchToDo(id: Int?) throws -> EditToDo.ToDo {
    throw MockToDoWorkerError.networkConnectionRequired
  }

  public func deleteToDo(id: Int?) throws {

  }

  public func editToDo(_ toDo: EditToDo.ToDo) throws {
    throw MockToDoWorkerError.unknownError
  }
}

// MARK: Mock Data

extension ToDoWorker {
  enum MockData {
    enum FetchToDo {
      static let firstData = EditToDo.ToDo(
        name: "영단어 30개 외우기",
        groupData: EditToDo.Group(id: 002, name: "영어", color: UIColor.toDoGardenRed),
        alarm: EditToDo.ToDoAlarm(
          isAlarmOn: false,
          alarmTime: nil
        ),
        repetition: EditToDo.ToDoRepetition(
          isOnlyToday: true,
          isRepeatEveryday: false,
          startDate: nil,
          endDate: nil
        )
      )

      static let secondData = EditToDo.ToDo(
        name: "네트워크 강의 복습",
        groupData: EditToDo.Group(id: 001, name: "CS 지식", color: UIColor.toDoGardenBrown),
        alarm: EditToDo.ToDoAlarm(
          isAlarmOn: true,
          alarmTime: 72000
        ),
        repetition: EditToDo.ToDoRepetition(
          isOnlyToday: false,
          isRepeatEveryday: true,
          startDate: nil,
          endDate: nil
        )
      )

      static let thirdData = EditToDo.ToDo(
        name: "천체 Chapter 복습",
        groupData: EditToDo.Group(id: 007, name: "지구과학", color: UIColor.toDoGardenGreenDark),
        alarm: EditToDo.ToDoAlarm(
          isAlarmOn: true,
          alarmTime: 11520
        ),
        repetition: EditToDo.ToDoRepetition(
          isOnlyToday: false,
          isRepeatEveryday: false,
          startDate: DateComponents(
            calendar: ToDoWorker.MockData.FetchToDo.defaultCalendar,
            year: 2024,
            month: 6,
            day: 22
          ).date,
          endDate: DateComponents(
            calendar: ToDoWorker.MockData.FetchToDo.defaultCalendar,
            year: 2024,
            month: 7,
            day: 03
          ).date
        )
      )

      static let defaultCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
    }
  }
}

// MARK: Error

extension ToDoWorker {
  enum MockToDoWorkerError: Error, CustomStringConvertible {
    case unknownError
    case networkConnectionRequired

    var description: String {
      switch self {
      case MockToDoWorkerError.unknownError:
        return "잠시 후\n 다시 시도해주세요!"
      case MockToDoWorkerError.networkConnectionRequired:
        return "네트워크 연결이 불안정합니다."
      }
    }
  }
}
