//
//  EditToDoInteractorTests.swift
//
//
//  Created by Wood on 8/8/24.
//

import Testing
import UIKit.UIColor

@testable import EditToDoScene
@testable import EditToDoSceneEntity

@Suite("EditToDoInteractor tests") struct EditToDoInteractorTest {
  let mockToDoWorker: MockToDoWorkLogicSpy
  let mockGroupWorker: MockGroupWorkLogicSpy
  let interactor: EditToDoInteractor
  let mockPresenter: EditToDoPresentationLogicSpy

  init() {
    self.mockToDoWorker = MockToDoWorkLogicSpy()
    self.mockGroupWorker = MockGroupWorkLogicSpy()
    self.mockPresenter = EditToDoPresentationLogicSpy()
    self.interactor = EditToDoInteractor(
      someWorker: EditToDoWorker(),
      toDoWorker: self.mockToDoWorker,
      groupWorker: self.mockGroupWorker
    )
    self.interactor.presenter = self.mockPresenter
  }

  @Test(
    "투두 데이터를 불러올 때 아이디가 있으면 ToDoWorker와 GroupWorker를 호출하고 EditToDoPresenter에 투두 데이터를 전달하는가"
  ) func test_투두_데이터를_불러올때_아이디가_있으면_ToDoWorker와_GroupWorker를_호출하고_EditToDoPresenter에_투두데이터를_전달하는가() throws {
    let request = EditToDo.FetchToDo.Request()
    self.interactor.toDoId = 100
    let expectedRepetitionViewState: EditToDo.EditToDoRepetitionViewState = .repeatOnlyToday

    self.interactor.fetchToDo(request: request)

    #expect(self.mockToDoWorker.isFetchToDoCalled)
    #expect(self.mockGroupWorker.isFetchGroupListCalled)
    let fetchResult = try #require(self.mockPresenter.fetchResult)
    switch fetchResult {
    case .success(let fetchedToDo):
      let toDo = try #require(self.interactor.toDo)
      // TODO: fetchedToDo가 올바른지 20개의 변수가 올바른지 확인?
      #expect(toDo.name == fetchedToDo.toDo.name)
      #expect(toDo.groupData.id == fetchedToDo.toDo.groupData.id)
      #expect(toDo.groupData.name == fetchedToDo.toDo.groupData.name)
      #expect(toDo.groupData.color == fetchedToDo.toDo.groupData.color)
      #expect(toDo.alarm.isAlarmOn == fetchedToDo.toDo.alarm.isAlarmOn)
      #expect(toDo.alarm.alarmTime == fetchedToDo.toDo.alarm.alarmTime)
      #expect(toDo.repetition.isOnlyToday == fetchedToDo.toDo.repetition.isOnlyToday)
      #expect(toDo.repetition.isRepeatEveryday == fetchedToDo.toDo.repetition.isRepeatEveryday)
      #expect(toDo.repetition.startDate == fetchedToDo.toDo.repetition.startDate)
      #expect(toDo.repetition.endDate == fetchedToDo.toDo.repetition.endDate)
      #expect(fetchedToDo.repetitionViewState == expectedRepetitionViewState)
    case .failure(let error):
      #expect(Bool(false), "투두 데이터를 받아오는데 실패했습니다. error: \(error)")
    }
    #expect(self.mockPresenter.isPresentFetchedToDoCalled)
  }
}

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
