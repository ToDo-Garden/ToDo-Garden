//
//  EditToDoInteractor.swift
//
//
//  Created by Wood on 6/29/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import EditToDoSceneAPI
import EditToDoSceneEntity
import SharedEntity
import TDFoundation

@MainActor
protocol EditToDoDataStore {
  var toDo: TodoBatchItem? { get set }
  var groups: [SharedEntity.TodoListGroup]? { get set }
}

@MainActor
protocol EditToDoBusinessLogic {
  func changeRepetition(isOnlyToday: Bool)
  func changeReptitionRange(request: EditToDo.ChangeRepetitionRange.Request)
  func changeAlarmActivation()
  func fetchAlarmTime()
  func changeAlarmTime(request: EditToDo.ChangeAlarmTime.Request)

  func prepareSceneData()
  func deleteToDo()
  func editToDo(request: EditToDo.CompleteEditToDo.Request)
}

@MainActor
final class EditToDoInteractor: EditToDoDataStore {
  var toDo: TodoBatchItem?
  var groups: [SharedEntity.TodoListGroup]?

  // MARK: VIP Objects
  var presenter: EditToDoPresentationLogic?
}

// MARK: - Non-REST API Logics

extension EditToDoInteractor: EditToDoBusinessLogic {
  func prepareSceneData() {
    if let toDo = self.toDo, let groups = self.groups {
      self.presenter?.presentFetchedToDo(toDo: toDo, groups: groups)
    } else {
      self.presenter?.presentError(EditToDo.ErrorType.failToFetch)
    }
  }

  /// 사용자가 투두 알림 스위치를 통해 활성화 여부를 변경했을 때 호출되는 메서드입니다.
  func changeAlarmActivation() {
//    self.toDo.isAlarmOn.toggle()
//    let response = EditToDo.ChangeAlarmActivation.Response(isAlarmOn: self.toDo.isAlarmOn)
//    self.presenter?.presentAlarmActivation(response: response)
  }

  /// 사용자가 투두 알림 시간 설정 버튼을 눌렀을 때, 기존에 설정했던 시간을 보여주기 위해 호출되는 메서드입니다.
  func fetchAlarmTime() {
//    let alarmTime = self.toDo?.alarm.alarmTime
//    let response = EditToDo.FetchAlarmTime.Response(alarmTime: alarmTime)
//    self.presenter?.presentFetchedAlarmTime(response: response)
  }

  func changeAlarmTime(request: EditToDo.ChangeAlarmTime.Request) {
//    let alarmTime = request.alarmTime
//    self.toDo?.alarm.alarmTime = alarmTime
//    let response = EditToDo.ChangeAlarmTime.Response(alarmTime: alarmTime)
//    self.presenter?.presentChangedAlarmTime(response: response)
  }

  func changeRepetition(isOnlyToday: Bool) {
//    self.toDo?.repetition.isOnlyToday = isOnlyToday
//    if isOnlyToday {
//      self.presenter?.presentRepeatOnlyToday()
//    } else {
//      let currentDate = Date()
//      let tomorrowDate = currentDate.addingTimeInterval(60 * 60 * 24)
//      let repetition = self.toDo?.repetition
//      if repetition?.startDate == nil && repetition?.endDate == nil {
//        self.toDo?.repetition.startDate = currentDate
//        self.toDo?.repetition.endDate = tomorrowDate
//      }
//
//      let response = EditToDo.ChangeRepetitionRange.Response(
//        startDate: self.toDo?.repetition.startDate ?? currentDate,
//        endDate: self.toDo?.repetition.endDate ?? tomorrowDate
//      )
//      self.presenter?.presentChangedRepetitionRange(response: response)
  }

  /// 사용자가 투두 반복 설정 뷰를 선택했을 때 호출하는 메서드입니다.
  func changeReptitionRange(request: EditToDo.ChangeRepetitionRange.Request) {
//    self.toDo?.repetition.isOnlyToday = false
//    let startDate = request.startDate
//    let endDate = request.endDate
//    self.toDo?.repetition.startDate = startDate
//    self.toDo?.repetition.endDate = endDate
//
//    let response = EditToDo.ChangeRepetitionRange.Response(startDate: startDate, endDate: endDate)
//    self.presenter?.presentChangedRepetitionRange(response: response)
  }
}

// MARK: REST API Logics
import HTTPClient
import HTTPClientAPI

extension EditToDoInteractor {
  /// 서버에 투두의 수정을 요청하는 메서드입니다.
  func editToDo(request: EditToDo.CompleteEditToDo.Request) {
//    guard let toDo else {
//      self.presenter?.presentError(.failToFetch)
//      return
//    }
//
//    self.toDo?.name = request.toDoName
//    self.toDo?.groupData = EditToDo.Group(
//      id: request.displayedGroup.id,
//      name: request.displayedGroup.name,
//      color: request.displayedGroup.color.hexStringFromColor(),
//      orderIdx: 0
//    )
//
//    self.tasks[TaskKey.editToDo] = Task {
//      defer { self.tasks[TaskKey.editToDo] = nil }
//
//      do {
//        try Task.checkCancellation()
//        try await self.editToDoWorker.editToDo(toDo)
//        try Task.checkCancellation()
//        self.presenter?.presentDismiss()
//      } catch let error {
//        debugPrint(error.localizedDescription)
//        self.presenter?.presentError(.network)
//      }
//    }
  }

  /// 서버에 투두의 삭제를 요청하는 메서드입니다.
  func deleteToDo() {
//    guard let toDoId else {
//      self.presenter?.presentError(.failToFetch)
//      return
//    }
//
//    self.tasks[TaskKey.deleteToDo] = Task {
//      defer { self.tasks[TaskKey.deleteToDo] = nil }
//
//      do {
//        try Task.checkCancellation()
//        try await self.editToDoWorker.deleteToDo(id: toDoId)
//        try Task.checkCancellation()
//        self.presenter?.presentDismiss()
//      } catch let error {
//        debugPrint(error.localizedDescription)
//        self.presenter?.presentError(.network)
//      }
//    }
  }
}

// MARK: Errors

enum EditToDoInteractorError: Error {
  case toDoDataNotExisted
}

extension EditToDoInteractor {
  enum TaskKey {
    case fetchToDo
    case fetchGroup
    case deleteToDo
    case editToDo
  }
}
