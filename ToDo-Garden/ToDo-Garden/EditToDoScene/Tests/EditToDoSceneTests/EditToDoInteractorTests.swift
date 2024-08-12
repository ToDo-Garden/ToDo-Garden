//
//  EditToDoInteractorTests.swift
//
//
//  Created by Wood on 8/8/24.
//

import XCTest

@testable import EditToDoScene
@testable import EditToDoSceneEntity

class MockToDoPresenter: EditToDoPresentationLogic {
  var presentFetchToDoValidationClosure: ((
    _ fetchedToDo: EditToDo.FetchToDo.Response.FetchedToDo?,
    _ error: Error?
  ) -> Void)?
  var presentEditResultValidationClosure: ((_ error: Error?) -> Void)?
  var presentDeleteResultValidationClosure: ((_ error: Error?) -> Void)?
  var presentChangeAlarmValidationClosure: ((_ isAlarmOn: Bool) -> Void)?
  var presentRepetitionValidationClosure: ((_ repetition: EditToDo.EditToDoRepetitionViewState) -> Void)?

  init(
    presentFetchToDoValidationClosure: ((
      _ toDo: EditToDo.FetchToDo.Response.FetchedToDo?,
      _ error: Error?
    ) -> Void)? = { (_, _) in XCTFail("presentFetchResult unexpectedly called") },
    presentEditResultValidationClosure: (
      (_ error: Error?) -> Void)? = { _ in XCTFail("presentEditResult unexpectedly called") },
    presentDeleteResultValidationClosure: (
      (_ error: Error?) -> Void)? = { _ in XCTFail("presentDeleteResult unexpectedly called") },
    presentChangeAlarmValidationClosure: (
      (_ isAlarmOn: Bool) -> Void)? = { _ in XCTFail("presentChangeAlarm unexpectedly called") },
    presentRepetitionValidationClosure: ((
      _ repetition: EditToDo.EditToDoRepetitionViewState
    ) -> Void)? = { _ in XCTFail("presentChangedRepetition unexpectedly called") }
  ) {
    self.presentFetchToDoValidationClosure = presentFetchToDoValidationClosure
    self.presentEditResultValidationClosure = presentEditResultValidationClosure
    self.presentDeleteResultValidationClosure = presentDeleteResultValidationClosure
    self.presentChangeAlarmValidationClosure = presentChangeAlarmValidationClosure
    self.presentRepetitionValidationClosure = presentRepetitionValidationClosure
  }

  func presentFetchedToDo(response: EditToDoSceneEntity.EditToDo.FetchToDo.Response) {
    switch response.fetchResult {
    case .success(let fetchedToDo):
      self.presentFetchToDoValidationClosure?(fetchedToDo, nil)
    case .failure(let error):
      self.presentFetchToDoValidationClosure?(nil, error)
    }
  }

  func presentEditResult(response: EditToDoSceneEntity.EditToDo.CompleteEditToDo.Response) {
    switch response.editResult {
    case .success:
      self.presentEditResultValidationClosure?(nil)
    case .failure(let error):
      self.presentEditResultValidationClosure?(error)
    }
  }

  func presentDeleteResult(response: EditToDoSceneEntity.EditToDo.DeleteToDo.Response) {
    switch response.deleteResult {
    case .success:
      self.presentDeleteResultValidationClosure?(nil)
    case .failure(let error):
      self.presentDeleteResultValidationClosure?(error)
    }
  }

  func presentAlarmActivation(response: EditToDoSceneEntity.EditToDo.ChangeAlarmActivation.Response) {
    self.presentChangeAlarmValidationClosure?(response.isAlarmOn)
  }

  func presentChangedRepetition(response: EditToDoSceneEntity.EditToDo.ChangeRepetition.Response) {
    self.presentRepetitionValidationClosure?(response.editToDoRepetitionViewState)
  }

  func presentSomething(response: EditToDoSceneEntity.EditToDo.Something.Response) {}
}

struct MockToDoWorker: ToDoWorkLogic {
  func fetchToDo(id: Int?) throws -> EditToDoSceneEntity.EditToDo.ToDo {
    return EditToDoSceneTestData.Interactor.toDo
  }

  func deleteToDo(id: Int?) throws {

  }

  func editToDo(_ toDo: EditToDoSceneEntity.EditToDo.ToDo) throws {

  }
}

struct MockGroupWorker: GroupWorkLogic {
  func fetchGroupList() throws -> [EditToDoSceneEntity.EditToDo.Group] {
    return EditToDoSceneTestData.Interactor.groupList
  }
}
