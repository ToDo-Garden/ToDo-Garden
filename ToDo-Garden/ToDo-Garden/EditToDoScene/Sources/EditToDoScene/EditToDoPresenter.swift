//
//  EditToDoPresenter.swift
//  
//
//  Created by Wood on 6/29/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import EditToDoSceneEntity
import SharedEntity
import TDFoundation

@MainActor
protocol EditToDoPresentationLogic {
  func presentFetchedToDo(toDo: TodoBatchItem, groups: [TodoListGroup])
  func presentDismiss()
  func presentError(_ type: EditToDo.ErrorType)

  func presentAlarmActivation(response: EditToDo.ChangeAlarmActivation.Response)
  func presentFetchedAlarmTime(response: EditToDo.FetchAlarmTime.Response)
  func presentChangedAlarmTime(response: EditToDo.ChangeAlarmTime.Response)
  func presentRepeatOnlyToday()
  func presentRepeatOtherDays()
  func presentChangedRepetitionRange(start: Date, end: Date)
}

final class EditToDoPresenter {
  private let dateFormatter: DateFormatter

  weak var viewController: EditToDoDisplayLogic?

  init(dateFormatter: DateFormatter = defaultDateFormatter) {
    self.dateFormatter = dateFormatter
  }
}

// MARK: - Request to ViewController

extension EditToDoPresenter: EditToDoPresentationLogic {
  func presentFetchedToDo(toDo: TodoBatchItem, groups: [TodoListGroup]) {
    let alarmTime = self.makeAlarmTime(of: toDo.alarmTime)
    let alarmTimeString = String(format: "%02d:%02d", alarmTime.hour, alarmTime.minute)
    let viewModel = EditToDo.FetchToDo.ViewModel(toDo: toDo, alarmTime: alarmTimeString, groups: groups)
    self.viewController?.displayFetchedToDo(viewModel: viewModel)
  }

  func presentDismiss() {
    self.viewController?.displayDismiss()
  }

  func presentAlarmActivation(response: EditToDo.ChangeAlarmActivation.Response) {
    let viewModel = EditToDo.ChangeAlarmActivation.ViewModel(isAlarmOn: response.isAlarmOn)
    self.viewController?.displayChangedAlarm(viewModel: viewModel)
  }

  func presentFetchedAlarmTime(response: EditToDo.FetchAlarmTime.Response) {
    let alarmTime = self.makeAlarmTime(of: response.alarmTime)
    let viewModel = EditToDo.FetchAlarmTime.ViewModel(hour: alarmTime.hour, minute: alarmTime.minute)
    self.viewController?.displayFetchedAlarmTime(viewModel: viewModel)
  }

  func presentChangedAlarmTime(response: EditToDo.ChangeAlarmTime.Response) {
    let alarmTime = self.makeAlarmTime(of: response.alarmTime)
    let alarmTimeString = String(format: "%02d:%02d", alarmTime.hour, alarmTime.minute)
    let viewModel = EditToDo.ChangeAlarmTime.ViewModel(alarmTimeString: alarmTimeString)
    self.viewController?.displayChangedAlarmTime(viewModel: viewModel)
  }

  func presentRepeatOnlyToday() {
    self.viewController?.displayRepeatOnlyToday()
  }

  func presentRepeatOtherDays() {
    self.viewController?.displayRepeatOtherDays()
  }

  func presentChangedRepetitionRange(start: Date, end: Date) {
    self.viewController?.displayChangedRepetition(
      start: self.dateFormatter.string(from: start),
      end: self.dateFormatter.string(from: end)
    )
  }

  func presentError(_ type: EditToDo.ErrorType) {
    self.viewController?.showErrorAlert(type)
  }
}

// MARK: Private Functions

extension EditToDoPresenter {
  private struct AlarmTime {
    let hour: Int
    let minute: Int
  }

  private func makeAlarmTime(of time: Double?) -> AlarmTime {
    if let time {
      let timeIntValue = Int(time)
      let secondsPerHour = 3600
      let secondsPerMinute = 60
      let hour = timeIntValue / secondsPerHour
      let minute = (timeIntValue - (hour * secondsPerHour)) / secondsPerMinute
      return AlarmTime(hour: hour, minute: minute)
    } else {
      return AlarmTime(hour: 0, minute: 0)
    }
  }

  private func makeDayString(from date: Date?) -> String? {
    if let date {
      return self.dateFormatter.string(from: date)
    } else {
      return nil
    }
  }
}

extension EditToDoPresenter {
  static let defaultDateFormatter: DateFormatter = {
    var dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy.MM.dd"
    dateFormatter.timeZone = TimeZone.autoupdatingCurrent
    return dateFormatter
  }()
}
