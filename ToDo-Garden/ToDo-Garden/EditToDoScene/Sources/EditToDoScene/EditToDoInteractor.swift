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
  func changeReptition(request: EditToDo.ChangeRepetition.Request)
  func fetchToDo(request: EditToDo.FetchToDo.Request)
  func deleteToDo(request: EditToDo.DeleteToDo.Request)
  func editToDo(request: EditToDo.CompleteEditToDo.Request)
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
  /// 사용자가 투두 반복 설정 뷰를 선택했을 때 호출하는 메서드입니다.
  /// ex) 사용자가 화면에서 (오늘만 or 다른날도 or 매일) 할래요 뷰를 눌렀음
  func changeReptition(request: EditToDo.ChangeRepetition.Request) {
    let isOnlyToday = request.isOnlyToday
    let isEveryday = request.isEveryday
    let repetitionViewState = self.makeRepetitionViewState(isOnlyToday: isOnlyToday, isEveryday: isEveryday)
    let response = EditToDo.ChangeRepetition.Response(editToDoRepetitionViewState: repetitionViewState)
    self.presenter?.presentChangedRepetition(response: response)
  }

  /// 서버로부터 수정할 투두의 정보를 받아오는 메서드입니다.
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
  
  /// 서버에 투두의 삭제를 요청하는 메서드입니다.
  func deleteToDo(request: EditToDo.DeleteToDo.Request) {
    let result = self.toDoWorker.deleteToDo(id: self.toDoId)
    let response = EditToDo.DeleteToDo.Response(deleteResult: result)
    self.presenter?.presentDeleteResult(response: response)
  }

  /// 서버에 투두의 수정을 요청하는 메서드입니다.
  func editToDo(request: EditToDo.CompleteEditToDo.Request) {
    guard var editedToDo = self.toDo
    else {
      let response = EditToDo.CompleteEditToDo.Response(editResult: .success(false))
      self.presenter?.presentEditResult(response: response)
      return
    }

    editedToDo.name = request.toDoName
    let group = request.displayedGroup
    editedToDo.groupData = EditToDo.Group(id: group.id, name: group.name, color: group.color)
    
    let result = self.toDoWorker.editToDo(editedToDo)
    let response = EditToDo.CompleteEditToDo.Response(editResult: result)
    self.presenter?.presentEditResult(response: response)
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
