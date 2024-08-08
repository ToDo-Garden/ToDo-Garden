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

class MockGroupWorkLogicSpy: MockGroupWorkable {
  var isFetchGroupListCalled: Bool = false

  func fetchGroupList() throws -> [EditToDoSceneEntity.EditToDo.Group] {
    self.isFetchGroupListCalled = true
    return EditToDoSceneTestData.Interactor.groupList
  }
}

class MockToDoWorkLogicSpy: MockToDoWorkable {
  var isFetchToDoCalled: Bool = false
  var isEditToDoCalled: Bool = false
  var isDeleteToDoCalled: Bool = false

  func fetchToDo(id: Int?) throws -> EditToDo.ToDo {
    self.isFetchToDoCalled = true
    return EditToDoSceneTestData.Interactor.toDo
  }

  func editToDo(_ toDo: EditToDo.ToDo) throws {
    self.isEditToDoCalled = true
  }

  func deleteToDo(id: Int?) throws {
    self.isDeleteToDoCalled = true
  }
}
