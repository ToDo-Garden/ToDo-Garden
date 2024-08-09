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
      #expect(toDo == fetchedToDo.toDo)
    case .failure(let error):
      #expect(Bool(false), "투두 데이터를 받아오는데 실패했습니다. error: \(error)")
    }
    #expect(self.mockPresenter.isPresentFetchedToDoCalled)
  }

  @Test(
    "투두 데이터를 불러올 때 아이디가 없으면 ToDoWorker와 GroupWorker를 호출하지 않고 EditToDoPresenter에 에러를 전달하는가"
  ) func test_투두_데이터를_불러올때_아이디가_없으면_ToDoWorker와_GroupWorker를_호출하지_않고_EditToDoPresenter에_에러를_전달하는가() throws {
    let request = EditToDo.FetchToDo.Request()

    self.interactor.fetchToDo(request: request)

    #expect(self.mockToDoWorker.isFetchToDoCalled == false)
    #expect(self.mockGroupWorker.isFetchGroupListCalled == false)
    let fetchResult = try #require(mockPresenter.fetchResult)
    switch fetchResult {
    case .success:
      #expect(Bool(false), "투두 아이디가 존재하지 않는데 데이터를 불러왔습니다.")
    case .failure(let error):
      let interactorError = try #require(error as? EditToDoInteractor.EditToDoInteractorError)
      #expect(interactorError == EditToDoInteractor.EditToDoInteractorError.toDoDataNotExisted)
    }
    #expect(self.mockPresenter.isPresentFetchedToDoCalled)
  }

  @Test(
    "투두 수정 요청시 ToDoWorker를 호출하고 EditToDoPresenter에 성공을 전달하는가"
  ) func test_투두_수정_요청시_ToDoWorker를_호출하고_EditToDoPresenter에_성공을_전달하는가() throws {
    self.interactor.toDo = EditToDoSceneTestData.Interactor.toDo
    let request = EditToDo.CompleteEditToDo.Request(
      toDoName: "영어독해",
      displayedGroup: EditToDo.CompleteEditToDo.Request.DisplayedGroup(id: 005, name: "국어", color: UIColor.white)
    )

    self.interactor.editToDo(request: request)

    #expect(self.mockToDoWorker.isEditToDoCalled)
    let editResult = try #require(self.mockPresenter.editResult)
    switch editResult {
    case .success:
      #expect(true)
    case .failure(let error):
      #expect(Bool(false), "정상적인 투두 수정 요청이 실패했습니다. error: \(error)")
    }
    #expect(self.mockPresenter.isPresentEditResultCalled)
  }

  @Test(
    "투두 수정 요청시 투두가 존재하지 않으면 ToDoWorker를 호출하지 않고 EditToDoPresenter에 에러를 전달하는가"
  ) func test_투두_수정_요청시_투두가_존재하지_않으면_ToDoWorker를_호출하지_않고_EditToDoPresenter에_에러를_전달하는가() throws {
    let request = EditToDo.CompleteEditToDo.Request(
      toDoName: "영어독해",
      displayedGroup: EditToDo.CompleteEditToDo.Request.DisplayedGroup(id: 005, name: "국어", color: UIColor.white)
    )

    self.interactor.editToDo(request: request)

    #expect(self.mockToDoWorker.isEditToDoCalled == false)
    let editResult = try #require(self.mockPresenter.editResult)
    switch editResult {
    case .success:
      #expect(Bool(false), "투두 데이터가 존재하지 않음에도 불구하고 수정 요청이 성공했습니다.")
    case .failure(let someError):
      let error = try #require(someError as? EditToDoInteractor.EditToDoInteractorError)
      #expect(error == EditToDoInteractor.EditToDoInteractorError.toDoDataNotExisted)
    }
    #expect(self.mockPresenter.isPresentEditResultCalled)
  }

  @Test(
    "투두 삭제 요청시 ToDoWorker를 호출하고 EditToDoPresenter에 성공을 전달하는가"
  ) func test_투두_삭제_요청시_ToDoWorker를_호출하고_EditToDoPresenter에_성공을_전달하는가() throws {
    self.interactor.toDoId = 100
    let request = EditToDo.DeleteToDo.Request()

    self.interactor.deleteToDo(request: request)

    #expect(self.mockToDoWorker.isDeleteToDoCalled)
    let editResult = try #require(self.mockPresenter.deleteResult)
    switch editResult {
    case .success:
      #expect(true)
    case .failure(let error):
      #expect(Bool(false), "정상적인 투두 삭제 요청이 실패했습니다. error: \(error)")
    }
    #expect(self.mockPresenter.isPresentDeleteResultCalled)
  }

  @Test(
    "투두 삭제 요청시 투두 ID가 존재하지 않으면 ToDoWorker를 호출하지 않고 EditToDoPresenter에 에러를 전달하는가"
  ) func test_투두_삭제_요청시_투두_ID가_존재하지_않으면_ToDoWorker를_호출하지_않고_EditToDoPresenter에_에러를_전달하는가() throws {
    let request = EditToDo.DeleteToDo.Request()

    self.interactor.deleteToDo(request: request)

    #expect(self.mockToDoWorker.isDeleteToDoCalled == false)
    let editResult = try #require(self.mockPresenter.deleteResult)
    switch editResult {
    case .success:
      #expect(Bool(false), "투두 ID가 존재하지 않음에도 불구하고 삭제 요청이 성공했습니다.")
    case .failure(let someError):
      let error = try #require(someError as? EditToDoInteractor.EditToDoInteractorError)
      #expect(error == EditToDoInteractor.EditToDoInteractorError.toDoDataNotExisted)
    }
    #expect(self.mockPresenter.isPresentDeleteResultCalled)
  }

  @Test(
    "투두 알림을 활성화 하면 EditToDoPresenter를 호출하는가"
  ) func test_투두_알림을_활성화_하면_EditToDoPresenter를_호출하는가() throws {
    var toDo = EditToDoSceneTestData.Interactor.toDo
    toDo.alarm.isAlarmOn = false
    self.interactor.toDo = toDo
    let request = EditToDo.ChangeAlarmActivation.Request()

    self.interactor.changeAlarmActivation(request: request)

    let toDoData = try #require(self.interactor.toDo)
    #expect(toDoData.alarm.isAlarmOn)
    #expect(self.mockPresenter.isPresentAlarmActivationCalled)
  }

  @Test(
    "투두를 매일 반복하도록 설정하면 EditToDoPresenter를 호출하는가"
  ) func test_투두를_매일_반복하도록_설정하면_EditToDoPresenter를_호출하는가() throws {
    var toDo = EditToDoSceneTestData.Interactor.toDo
    toDo.repetition.isRepeatEveryday = false
    self.interactor.toDo = toDo
    let request = EditToDo.ChangeRepetition.Request(isOnlyToday: false, isEveryday: true)

    self.interactor.changeReptition(request: request)

    let toDoData = try #require(self.interactor.toDo)
    #expect(toDoData.repetition.isRepeatEveryday)
    #expect(self.mockPresenter.isPresentChangedRepetitionCalled)
    #expect(self.mockPresenter.repetitionViewState == .repeatEveryday)
  }

  @Test(
    "투두를 오늘만 반복하도록 설정하면 EditToDoPresenter를 호출하는가"
  ) func test_투두를_오늘만_반복하도록_설정하면_EditToDoPresenter를_호출하는가() throws {
    var toDo = EditToDoSceneTestData.Interactor.toDo
    toDo.repetition.isOnlyToday = false
    self.interactor.toDo = toDo
    let request = EditToDo.ChangeRepetition.Request(isOnlyToday: true, isEveryday: nil)

    self.interactor.changeReptition(request: request)

    let toDoData = try #require(self.interactor.toDo)
    #expect(toDoData.repetition.isOnlyToday)
    #expect(self.mockPresenter.isPresentChangedRepetitionCalled)
    #expect(self.mockPresenter.repetitionViewState == .repeatOnlyToday)
  }

  @Test(
    "투두를 일정 기간동안 반복하도록 설정하면 EditToDoPresenter를 호출하는가"
  ) func test_투두를_일정_기간동안_반복하도록_설정하면_EditToDoPresenter를_호출하는가() throws {
    var toDo = EditToDoSceneTestData.Interactor.toDo
    toDo.repetition.isRepeatEveryday = true
    self.interactor.toDo = toDo
    let request = EditToDo.ChangeRepetition.Request(isOnlyToday: false, isEveryday: false)

    self.interactor.changeReptition(request: request)

    let toDoData = try #require(self.interactor.toDo)
    #expect(toDoData.repetition.isRepeatEveryday == false)
    #expect(self.mockPresenter.isPresentChangedRepetitionCalled)
    #expect(self.mockPresenter.repetitionViewState == .repeatInRange)
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

class MockGroupWorkLogicSpy: GroupWorkLogic {
  var isFetchGroupListCalled: Bool = false

  func fetchGroupList() throws -> [EditToDoSceneEntity.EditToDo.Group] {
    self.isFetchGroupListCalled = true
    return EditToDoSceneTestData.Interactor.groupList
  }
}

class MockToDoWorkLogicSpy: ToDoWorkLogic {
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
