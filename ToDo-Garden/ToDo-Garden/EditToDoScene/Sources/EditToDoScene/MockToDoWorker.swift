//
//  MockToDoWorker.swift
//
//
//  Created by Wood on 7/27/24.
//

import UIKit.UIColor

import EditToDoSceneEntity

/// ToDo Context를 가정한 Mock Worker 입니다.
public final class MockToDoWorker {
  public init() {}

  func fetchToDo(id: Int?) throws(MockToDoWorkerError) -> EditToDo.ToDo {
    return MockData.FetchToDo.firstData
  }

  func deleteToDo(id: Int?) throws(MockToDoWorkerError) {

  }

  func editToDo(_ toDo: EditToDo.ToDo) throws(MockToDoWorkerError) {
    throw MockToDoWorkerError.unknownError
  }
}

// MARK: Mock Data

extension MockToDoWorker {
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
            calendar: MockToDoWorker.MockData.FetchToDo.defaultCalendar,
            year: 2024,
            month: 6,
            day: 22
          ).date,
          endDate: DateComponents(
            calendar: MockToDoWorker.MockData.FetchToDo.defaultCalendar,
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

extension MockToDoWorker {
  enum MockToDoWorkerError: Error {
    case unknownError
  }
}
