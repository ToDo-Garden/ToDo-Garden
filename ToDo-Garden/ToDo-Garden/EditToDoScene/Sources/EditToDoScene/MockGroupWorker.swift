//
//  MockGroupWorker.swift
//
//
//  Created by Wood on 7/27/24.
//

import UIKit.UIColor

import EditToDoSceneEntity

/// Group Context를 가정한 Mock Worker 입니다.
public final class MockGroupWorker {
  public init() {}

  func fetchGroupList() throws -> [EditToDo.Group] {
    return MockData.groupList
  }
}

// MARK: Mock Data

extension MockGroupWorker {
  enum MockData {
    static let groupList = [
      EditToDo.Group(id: 001, name: "CS 지식", color: UIColor.toDoGardenBrown),
      EditToDo.Group(id: 002, name: "영어", color: UIColor.toDoGardenRed),
      EditToDo.Group(id: 003, name: "국어", color: UIColor.toDoGardenBlue),
      EditToDo.Group(id: 004, name: "수학", color: UIColor.toDoGardenMint),
      EditToDo.Group(id: 005, name: "Swift", color: UIColor.toDoGardenYellow),
      EditToDo.Group(id: 006, name: "런닝", color: UIColor.toDoGardenPurple),
      EditToDo.Group(id: 007, name: "지구과학", color: UIColor.toDoGardenGreenDark),
      EditToDo.Group(id: 008, name: "물리", color: UIColor.toDoGardenOrange)
    ]
  }
}
