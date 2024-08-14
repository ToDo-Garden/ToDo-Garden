//
//  EditToDoSceneTestData.swift
//
//
//  Created by Wood on 8/8/24.
//

import UIKit

@testable import EditToDoSceneEntity

enum EditToDoSceneTestData {
  enum Interactor {
    static let toDoId = 100
    static let toDo = EditToDo.ToDo(
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
    static let groupList: [EditToDo.Group] = [
      EditToDo.Group(id: 001, name: "CS 지식", color: UIColor.toDoGardenBrown),
      EditToDo.Group(id: 002, name: "영어", color: UIColor.toDoGardenRed),
      EditToDo.Group(id: 003, name: "국어", color: UIColor.toDoGardenBlue)
    ]
    static let fetchedToDo = EditToDo.FetchToDo.Response.FetchedToDo(
      toDo: toDo,
      groupList: groupList,
      repetitionViewState: .repeatOnlyToday
    )
    static let toDoNameForEdit = "투두"
    static let groupForEdit = EditToDo.Group(id: 000, name: "그룹 1", color: UIColor.red)
  }
}
