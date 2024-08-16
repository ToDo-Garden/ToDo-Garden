//
//  EditToDoPresenter.swift
//  
//
//  Created by Wood on 6/29/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import EditToDoSceneEntity

protocol EditToDoPresentationLogic {
  func presentFetchedToDo(response: EditToDo.FetchToDo.Response)
  func presentDeleteResult(response: EditToDo.DeleteToDo.Response)
  func presentEditResult(response: EditToDo.CompleteEditToDo.Response)
  func presentAlarmActivation(response: EditToDo.ChangeAlarmActivation.Response)
  func presentChangedRepetition(response: EditToDo.ChangeRepetition.Response)
}

class EditToDoPresenter {
  private let dateFormatter: DateFormatter

  weak var viewController: EditToDoDisplayLogic?

  init(dateFormatter: DateFormatter = defaultDateFormatter) {
    self.dateFormatter = dateFormatter
  }
}

// MARK: - Request to ViewController

extension EditToDoPresenter: EditToDoPresentationLogic {
  func presentFetchedToDo(response: EditToDo.FetchToDo.Response) {
    switch response.fetchResult {
    case Result.success(let fetchedToDo):
      let displayedToDo = self.makeDisplayedToDo(from: fetchedToDo)
      let viewModel = EditToDo.FetchToDo.ViewModel(fetchedToDoResult: Result.success(displayedToDo))
      self.viewController?.displayFetchedToDo(viewModel: viewModel)
    case Result.failure(let error):
      let viewModel = EditToDo.FetchToDo.ViewModel(fetchedToDoResult: Result.failure(error))
      self.viewController?.displayFetchedToDo(viewModel: viewModel)
    }
  }
  
  func presentDeleteResult(response: EditToDo.DeleteToDo.Response) {
    switch response.deleteResult {
    case Result.success:
      let viewModel = EditToDo.DeleteToDo.ViewModel(deleteResult: Result.success(()))
      self.viewController?.displayDeleteToDoResult(viewModel: viewModel)
    case Result.failure(let error):
      let viewModel = EditToDo.DeleteToDo.ViewModel(deleteResult: Result.failure(error))
      self.viewController?.displayDeleteToDoResult(viewModel: viewModel)
    }
  }

  func presentEditResult(response: EditToDo.CompleteEditToDo.Response) {
    switch response.editResult {
    case Result.success:
      let viewModel = EditToDo.CompleteEditToDo.ViewModel(editResult: Result.success(()))
      self.viewController?.displayEditToDoResult(viewModel: viewModel)
    case Result.failure(let error):
      let viewModel = EditToDo.CompleteEditToDo.ViewModel(editResult: Result.failure(error))
      self.viewController?.displayEditToDoResult(viewModel: viewModel)
    }
  }

  func presentAlarmActivation(response: EditToDo.ChangeAlarmActivation.Response) {}
  func presentChangedRepetition(response: EditToDo.ChangeRepetition.Response) {}
}

// MARK: Private Functions

extension EditToDoPresenter {
  private func makeDisplayedToDo(
    from fetchedToDo: EditToDo.FetchToDo.Response.FetchedToDo
  ) -> EditToDo.FetchToDo.ViewModel.DisplayedToDo {
    let alarmTime = self.makeAlarmTimeString(from: fetchedToDo.toDo.alarm.alarmTime)
    let startDay = self.makeDayString(from: fetchedToDo.toDo.repetition.startDate)
    let endDay = self.makeDayString(from: fetchedToDo.toDo.repetition.endDate)

    return EditToDo.FetchToDo.ViewModel.DisplayedToDo(
      toDoName: fetchedToDo.toDo.name,
      group: fetchedToDo.toDo.groupData,
      groupList: fetchedToDo.groupList,
      isAlarmOn: fetchedToDo.toDo.alarm.isAlarmOn,
      alarmTime: alarmTime,
      repetitionViewState: fetchedToDo.repetitionViewState,
      startDay: startDay,
      endDay: endDay
    )
  }

  private func makeAlarmTimeString(from time: Double?) -> String? {
    if let time = time {
      let timeIntValue = Int(time)
      let secondsPerHour = 3600
      let secondsPerMinute = 60
      let hour = timeIntValue / secondsPerHour
      let minute = (timeIntValue - (hour * secondsPerHour)) % secondsPerMinute
      return String(format: "%02d:%02d", hour, minute)
    } else {
      return nil
    }
  }

  private func makeDayString(from date: Date?) -> String? {
    if let unwarppedDate = date {
      return self.dateFormatter.string(from: unwarppedDate)
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
