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
  var toDoId: UUID? { get set }
}

protocol EditToDoBusinessLogic {
  func changeRepetition(isOnlyToday: Bool)
  func changeReptitionRange(request: EditToDo.ChangeRepetitionRange.Request)
  func changeAlarmActivation()
  func fetchAlarmTime()
  func changeAlarmTime(request: EditToDo.ChangeAlarmTime.Request)
  func fetchToDo()
  func deleteToDo()
  func editToDo(request: EditToDo.CompleteEditToDo.Request)
}

final class EditToDoInteractor: EditToDoDataStore {
  var toDoId: UUID?
  var toDo: EditToDo.ToDo?

  // MARK: VIP Objects
  var presenter: EditToDoPresentationLogic?
  private let toDoWorker: ToDoWorkLogic
  private let groupWorker: GroupWorkLogic

  public init(
    toDoWorker: ToDoWorkLogic,
    groupWorker: GroupWorkLogic
  ) {
    self.toDoWorker = toDoWorker
    self.groupWorker = groupWorker
  }
}

// MARK: - Request to worker

extension EditToDoInteractor: EditToDoBusinessLogic {
  /// 사용자가 투두 알림 스위치를 통해 활성화 여부를 변경했을 때 호출되는 메서드입니다.
  func changeAlarmActivation() {
    guard let isAlarmOn = self.toDo?.alarm.isAlarmOn
    else { return }

    self.toDo?.alarm.isAlarmOn = !isAlarmOn
    let response = EditToDo.ChangeAlarmActivation.Response(isAlarmOn: !isAlarmOn)
    self.presenter?.presentAlarmActivation(response: response)
  }

  /// 사용자가 투두 알림 시간 설정 버튼을 눌렀을 때, 기존에 설정했던 시간을 보여주기 위해 호출되는 메서드입니다.
  func fetchAlarmTime() {
    let alarmTime = self.toDo?.alarm.alarmTime
    let response = EditToDo.FetchAlarmTime.Response(alarmTime: alarmTime)
    self.presenter?.presentFetchedAlarmTime(response: response)
  }

  func changeAlarmTime(request: EditToDo.ChangeAlarmTime.Request) {
    let alarmTime = request.alarmTime
    self.toDo?.alarm.alarmTime = alarmTime
    let response = EditToDo.ChangeAlarmTime.Response(alarmTime: alarmTime)
    self.presenter?.presentChangedAlarmTime(response: response)
  }

  func changeRepetition(isOnlyToday: Bool) {
    self.toDo?.repetition.isOnlyToday = isOnlyToday
    if isOnlyToday {
      self.presenter?.presentRepeatOnlyToday()
    } else {
      let currentDate = Date()
      let tomorrowDate = currentDate.addingTimeInterval(60 * 60 * 24)
      let repetition = self.toDo?.repetition
      if repetition?.startDate == nil && repetition?.endDate == nil {
        self.toDo?.repetition.startDate = currentDate
        self.toDo?.repetition.endDate = tomorrowDate
      }

      let response = EditToDo.ChangeRepetitionRange.Response(
        startDate: self.toDo?.repetition.startDate ?? currentDate,
        endDate: self.toDo?.repetition.endDate ?? tomorrowDate
      )
      self.presenter?.presentChangedRepetitionRange(response: response)
    }
  }

  /// 사용자가 투두 반복 설정 뷰를 선택했을 때 호출하는 메서드입니다.
  func changeReptitionRange(request: EditToDo.ChangeRepetitionRange.Request) {
    self.toDo?.repetition.isOnlyToday = false
    let startDate = request.startDate
    let endDate = request.endDate
    self.toDo?.repetition.startDate = startDate
    self.toDo?.repetition.endDate = endDate

    let response = EditToDo.ChangeRepetitionRange.Response(startDate: startDate, endDate: endDate)
    self.presenter?.presentChangedRepetitionRange(response: response)
  }

  /// 서버로부터 수정할 투두의 정보를 받아오는 메서드입니다.
  func fetchToDo() {
    let fetchResult: Result<EditToDo.FetchToDo.Response.FetchedToDo, Error>
    do {
      guard let toDoId = self.toDoId
      else { throw EditToDoInteractorError.toDoDataNotExisted }

      let toDo = try self.toDoWorker.fetchToDo(id: toDoId)
      self.toDo = toDo
      let group = try self.groupWorker.fetchGroupList()
      let repetitionViewState = self.makeRepetitionViewState(
        isOnlyToday: toDo.repetition.isOnlyToday,
        isEveryday: toDo.repetition.isRepeatEveryday
      )

      let fetchedToDo = EditToDo.FetchToDo.Response.FetchedToDo(
        toDo: toDo,
        groupList: group,
        repetitionViewState: repetitionViewState
      )

      fetchResult = Result.success(fetchedToDo)
    } catch let error {
      fetchResult = Result.failure(error)
    }

    let response = EditToDo.FetchToDo.Response(fetchResult: fetchResult)
    self.presenter?.presentFetchedToDo(response: response)
  }
  
  /// 서버에 투두의 삭제를 요청하는 메서드입니다.
  func deleteToDo() {
    let deleteResult: Result<Void, Error>
    do {
      guard let toDoId = self.toDoId
      else { throw EditToDoInteractorError.toDoDataNotExisted }

      try self.toDoWorker.deleteToDo(id: toDoId)
      deleteResult = Result.success(())
    } catch let error {
      deleteResult = Result.failure(error)
    }

    let response = EditToDo.DeleteToDo.Response(deleteResult: deleteResult)
    self.presenter?.presentDeleteResult(response: response)
  }

  /// 서버에 투두의 수정을 요청하는 메서드입니다.
  func editToDo(request: EditToDo.CompleteEditToDo.Request) {
    let editResult: Result<Void, Error>
    do {
      let editedToDo = try self.makeToDoForEdit(with: request)
      try self.toDoWorker.editToDo(editedToDo)
      editResult = Result.success(())
    } catch let error {
      editResult = Result.failure(error)
    }

    let response = EditToDo.CompleteEditToDo.Response(editResult: editResult)
    self.presenter?.presentEditResult(response: response)
  }
}

// MARK: Private Functions

extension EditToDoInteractor {
  private func makeRepetitionViewState(
    isOnlyToday: Bool,
    isEveryday: Bool?
  ) -> EditToDo.EditToDoRepetitionViewState {
    self.toDo?.repetition.isOnlyToday = isOnlyToday
    if isOnlyToday {
      return EditToDo.EditToDoRepetitionViewState.repeatOnlyToday
    }

    let isRepeatEveryday = isEveryday ?? (self.toDo?.repetition.isRepeatEveryday ?? true)
    self.toDo?.repetition.isRepeatEveryday = isRepeatEveryday
    let state: EditToDo.EditToDoRepetitionViewState = isRepeatEveryday ? .repeatEveryday : .repeatInRange
    return state
  }

  private func makeToDoForEdit(
    with request: EditToDo.CompleteEditToDo.Request
  ) throws -> EditToDo.ToDo {
    guard var editedToDo = self.toDo
    else { throw EditToDoInteractorError.toDoDataNotExisted }

    editedToDo.name = request.toDoName
    editedToDo.groupData = EditToDo.Group(
      id: request.displayedGroup.id,
      name: request.displayedGroup.name,
      color: request.displayedGroup.color
    )

    return editedToDo
  }
}

// MARK: Errors

enum EditToDoInteractorError: Error {
  case toDoDataNotExisted
}
