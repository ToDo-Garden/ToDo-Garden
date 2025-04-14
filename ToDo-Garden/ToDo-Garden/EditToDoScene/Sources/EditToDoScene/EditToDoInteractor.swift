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
  func changeReptitionRange(start: Date, end: Date)
  func changeAlarmActivation()
  func fetchAlarmTime()
  func changeAlarmTime(_ time: Double)

  func prepareSceneData()
  func editToDo(name: String, groupId: String)
  func deleteToDo()
}

@MainActor
final class EditToDoInteractor: EditToDoDataStore {
  var toDo: TodoBatchItem?
  var groups: [SharedEntity.TodoListGroup]?

  // MARK: VIP Objects
  var presenter: EditToDoPresentationLogic?

  public init() {}
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
    self.toDo?.isAlarmOn.toggle()
    guard let isAlarmOn = self.toDo?.isAlarmOn else { return }
    let response = EditToDo.ChangeAlarmActivation.Response(isAlarmOn: isAlarmOn)
    self.presenter?.presentAlarmActivation(response: response)
  }

  /// 사용자가 투두 알림 시간 설정 버튼을 눌렀을 때, 기존에 설정했던 시간을 보여주기 위해 호출되는 메서드입니다.
  func fetchAlarmTime() {
    guard let alarmTime = self.toDo?.alarmTime else { return }
    let response = EditToDo.FetchAlarmTime.Response(alarmTime: alarmTime)
    self.presenter?.presentFetchedAlarmTime(response: response)
  }

  func changeAlarmTime(_ time: Double) {
    self.toDo?.alarmTime = time
    let response = EditToDo.ChangeAlarmTime.Response(alarmTime: time)
    self.presenter?.presentChangedAlarmTime(response: response)
  }

  func changeRepetition(isOnlyToday: Bool) {
    self.toDo?.isOnlyToday = isOnlyToday
    if isOnlyToday {
      self.presenter?.presentRepeatOnlyToday()
    } else {
      self.presenter?.presentRepeatOtherDays()
    }
  }

  /// 사용자가 투두 반복 설정 뷰를 선택했을 때 호출하는 메서드입니다.
  func changeReptitionRange(start: Date, end: Date) {
    self.toDo?.isOnlyToday = false
    self.toDo?.startDay = start.toISOString()
    self.toDo?.endDay = end.toISOString()
    self.presenter?.presentChangedRepetitionRange(start: start, end: end)
  }
}

// MARK: REST API Logics
import HTTPClient
import HTTPClientAPI

// swiftlint:disable multiline_arguments
extension EditToDoInteractor {
  /// 서버에 투두의 수정을 요청하는 메서드입니다.
  func editToDo(name: String, groupId: String) {
    guard let toDo = self.toDo
    else { return }

    let startDay = toDo.isOnlyToday ? nil : toDo.startDay
    let endDay = toDo.isOnlyToday ? nil : toDo.endDay
    self.toDo = TodoBatchItem(
      localId: toDo.localId, name: name, isDone: toDo.isDone, createdAt: toDo.createdAt,
      isAlarmOn: toDo.isAlarmOn, alarmTime: toDo.alarmTime, isOnlyToday: toDo.isOnlyToday,
      startDay: startDay, endDay: endDay, groupId: groupId, isDelete: false
    )
    self.presenter?.presentEditedToDo()
  }

  // TODO: 서버에 투두의 삭제를 요청하는 메서드입니다.
  func deleteToDo() {
  }
}
// swiftlint:enable multiline_arguments

// MARK: Errors

enum EditToDoInteractorError: Error {
  case toDoDataNotExisted
}
