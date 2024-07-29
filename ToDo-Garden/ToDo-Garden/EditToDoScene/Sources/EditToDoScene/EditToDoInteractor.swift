//
//  EditToDoInteractor.swift
//
//
//  Created by Wood on 6/29/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import EditToDoSceneAPI
import EditToDoSceneEntity

protocol EditToDoDataStore {
  var toDoId: Int? { get set }
}

protocol EditToDoBusinessLogic {
  func doSomething(request: EditToDo.Something.Request)
}

final class EditToDoInteractor: EditToDoDataStore {
  var toDoId: Int?

  // MARK: VIP Objects
  var presenter: EditToDoPresentationLogic?
  private let someWorker: EditToDoWorkable
  private let toDoWorker: MockToDoWorker
  private let groupWorker: MockGroupWorker

  public init(
    someWorker: EditToDoWorkable,
    toDoWorker: MockToDoWorker,
    groupWorker: MockGroupWorker
  ) {
    self.someWorker = someWorker
    self.toDoWorker = toDoWorker
    self.groupWorker = groupWorker
  }
}

// MARK: - Request to worker

extension EditToDoInteractor: EditToDoBusinessLogic {
  func doSomething(request: EditToDo.Something.Request) {
    self.someWorker.doSomeWork()

    let response = EditToDo.Something.Response()
    self.presenter?.presentSomething(response: response)
  }
}
