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
  func fetchToDo(request: EditToDo.FetchToDo.Request)
  func doSomething(request: EditToDo.Something.Request)
}

final class EditToDoInteractor: EditToDoDataStore {
  private var toDo: EditToDo.ToDo?
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
  func fetchToDo(request: EditToDo.FetchToDo.Request) {
    guard let toDoData = try? self.toDoWorker.fetchToDo(id: self.toDoId),
      let groupList = try? self.groupWorker.fetchGroupList()
    else { return }

    self.toDo = toDoData
    
    let isOnlyToday = toDoData.repetition.isOnlyToday
    let isEveryday = toDoData.repetition.isRepeatEveryday
    let repetitionViewState = self.makeRepetitionViewState(isOnlyToday: isOnlyToday, isEveryday: isEveryday)
    let response = EditToDo.FetchToDo.Response(
      toDo: toDoData,
      groupList: groupList,
      repetitionViewState: repetitionViewState
    )
    self.presenter?.presentFetchedToDo(response: response)
  }
  
  /// EditToDoViewController 컴파일 에러 방지 코드입니다.
  func doSomething(request: EditToDo.Something.Request) {}
}

// MARK: Private Functions

extension EditToDoInteractor {
  private func makeRepetitionViewState(
    isOnlyToday: Bool,
    isEveryday: Bool?
  ) -> EditToDo.EditToDoRepetitionViewState {
    self.toDo?.repetition.isOnlyToday = isOnlyToday
    guard isOnlyToday == false
    else { return EditToDo.EditToDoRepetitionViewState.repeatOnlyToday }

    let isRepeatEveryday = isEveryday ?? (self.toDo?.repetition.isRepeatEveryday ?? true)
    self.toDo?.repetition.isRepeatEveryday = isRepeatEveryday
    guard isRepeatEveryday == false
    else { return EditToDo.EditToDoRepetitionViewState.repeatEveryday }

    return EditToDo.EditToDoRepetitionViewState.repeatInRange
  }
}
