//
//  EditToDoPresenter.swift
//  
//
//  Created by Wood on 6/29/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import EditToDoSceneEntity

protocol EditToDoPresentationLogic {
  func presentAlarmActivation(response: EditToDo.ChangeAlarmActivation.Response)
  func presentChangedRepetition(response: EditToDo.ChangeRepetition.Response)
  func presentFetchedToDo(response: EditToDo.FetchToDo.Response)
  func presentDeleteResult(response: EditToDo.DeleteToDo.Response)
  func presentEditResult(response: EditToDo.CompleteEditToDo.Response)
}

class EditToDoPresenter {
  weak var viewController: EditToDoDisplayLogic?
}

// MARK: - Request to ViewController

extension EditToDoPresenter: EditToDoPresentationLogic {
  func presentAlarmActivation(response: EditToDo.ChangeAlarmActivation.Response) {}
  func presentChangedRepetition(response: EditToDo.ChangeRepetition.Response) {}
  func presentFetchedToDo(response: EditToDo.FetchToDo.Response) {}
  func presentDeleteResult(response: EditToDo.DeleteToDo.Response) {}
  func presentEditResult(response: EditToDo.CompleteEditToDo.Response) {}
}
