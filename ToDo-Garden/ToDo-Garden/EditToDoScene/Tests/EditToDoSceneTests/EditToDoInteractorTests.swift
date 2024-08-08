//
//  EditToDoInteractorTests.swift
//
//
//  Created by Wood on 8/8/24.
//

@testable import EditToDoScene
@testable import EditToDoSceneEntity

class EditToDoPresentationLogicSpy: EditToDoPresentationLogic {
  var fetchResult: Result<EditToDo.FetchToDo.Response.FetchedToDo, Error>?
  var isPresentFetchedToDoCalled = false

  var editResult: Result<Void, Error>?
  var isPresentEditResultCalled = false

  var deleteResult: Result<Void, Error>?
  var isPresentDeleteResultCalled = false

  var isPresentAlarmActivationCalled = false

  var repetitionViewState: EditToDo.EditToDoRepetitionViewState?
  var isPresentChangedRepetitionCalled = false

  func presentFetchedToDo(response: EditToDo.FetchToDo.Response) {
    self.fetchResult = response.fetchResult
    self.isPresentFetchedToDoCalled = true
  }

  func presentEditResult(response: EditToDo.CompleteEditToDo.Response) {
    self.editResult = response.editResult
    self.isPresentEditResultCalled = true
  }

  func presentDeleteResult(response: EditToDo.DeleteToDo.Response) {
    self.isPresentDeleteResultCalled = true
    self.deleteResult = response.deleteResult
  }

  func presentAlarmActivation(response: EditToDo.ChangeAlarmActivation.Response) {
    self.isPresentAlarmActivationCalled = true
  }

  func presentChangedRepetition(response: EditToDo.ChangeRepetition.Response) {
    self.repetitionViewState = response.editToDoRepetitionViewState
    self.isPresentChangedRepetitionCalled = true
  }

  func presentSomething(response: EditToDo.Something.Response) {}
}
