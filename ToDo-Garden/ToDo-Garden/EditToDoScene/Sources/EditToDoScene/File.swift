//
//  MockToDoWorker.swift
//
//
//  Created by Wood on 7/27/24.
//

import UIKit.UIColor

import EditToDoSceneEntity

/// ToDo Context를 가정한 Mock Worker 입니다.
final class MockToDoWorker {
  func fetchToDo(id: Int?) throws -> EditToDo.ToDo {
    return MockData.FetchToDo.firstData
  }

  func deleteToDo(id: Int?) -> Result<Bool, Error> {
    return Result.success(true)
  }

  func editToDo(_ toDo: EditToDo.ToDo?) -> Result<Bool, Error> {
    return Result.success(true)
  }
}
