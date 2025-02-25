//
//  EditToDoPresenter.swift
//  
//
//  Created by Wood on 6/29/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import EditToDoSceneEntity

@MainActor
protocol EditToDoPresentationLogic {
  func presentFetchedToDo(response: EditToDo.FetchToDo.Response)
  func presentFetchedGroupList(groupList: [EditToDo.Group])
  func presentDismiss()
  func presentError(_ type: EditToDo.ErrorType)

  func presentAlarmActivation(response: EditToDo.ChangeAlarmActivation.Response)
  func presentFetchedAlarmTime(response: EditToDo.FetchAlarmTime.Response)
  func presentChangedAlarmTime(response: EditToDo.ChangeAlarmTime.Response)
  func presentRepeatOnlyToday()
  func presentChangedRepetitionRange(response: EditToDo.ChangeRepetitionRange.Response)
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
  func presentFetchedToDo(response: EditToDo.FetchToDo.Response) {
    let viewModel = EditToDo.FetchToDo.ViewModel(toDo: self.makeDisplayedToDo(from: response.toDo))
    self.viewController?.displayFetchedToDo(viewModel: viewModel)
  }

  func presentFetchedGroupList(groupList: [EditToDo.Group]) {
    let displayedGroupList = groupList.map {
      return EditToDo.DisplayedGroup(
        id: $0.id,
        name: $0.name,
        color: (try? UIColor().fromHex($0.color)) ?? UIColor.toDoGardenGreenDark,
        orderIdx: $0.orderIdx
      )
    }
    self.viewController?.displayFetchedGroupList(displayedGroupList)
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

  func presentChangedRepetitionRange(response: EditToDo.ChangeRepetitionRange.Response) {
    let startDay = self.dateFormatter.string(from: response.startDate)
    let endDay = self.dateFormatter.string(from: response.endDate)
    let viewModel = EditToDo.ChangeRepetitionRange.ViewModel(startDay: startDay, endDay: endDay)
    self.viewController?.displayChangedRepetition(viewModel: viewModel)
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

  private func makeDisplayedToDo(
    from fetchedToDo: EditToDo.ToDo
  ) -> EditToDo.FetchToDo.ViewModel.DisplayedToDo {
    let displayedGroup = EditToDo.DisplayedGroup(
      id: fetchedToDo.groupData.id,
      name: fetchedToDo.groupData.name,
      color: (try? UIColor().fromHex(fetchedToDo.groupData.color)) ?? UIColor.toDoGardenGreenDark,
      orderIdx: fetchedToDo.groupData.orderIdx
    )
    let alarmTime = self.makeAlarmTime(of: fetchedToDo.alarm.alarmTime)
    let alarmTimeString = String(format: "%02d:%02d", alarmTime.hour, alarmTime.minute)
    let startDay = self.makeDayString(from: fetchedToDo.repetition.startDate)
    let endDay = self.makeDayString(from: fetchedToDo.repetition.endDate)

    return EditToDo.FetchToDo.ViewModel.DisplayedToDo(
      toDoName: fetchedToDo.name,
      group: displayedGroup,
      isAlarmOn: fetchedToDo.alarm.isAlarmOn,
      alarmTime: alarmTimeString,
      isOnlyToday: fetchedToDo.repetition.isOnlyToday,
      startDay: startDay,
      endDay: endDay
    )
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
