//
//  EditToDoInteractorTests.swift
//
//
//  Created by Wood on 8/8/24.
//

import XCTest

@testable import EditToDoScene
@testable import EditToDoSceneEntity

class EditToDoInteractorTests: XCTestCase {
  func test_투두_아이디가_존재하면_투두를_성공적으로_조회하는가() throws {
    let mockToDoWorker = MockToDoWorker()
    let mockGroupWorker = MockGroupWorker()
    let interactor = EditToDoInteractor(
      toDoWorker: mockToDoWorker,
      groupWorker: mockGroupWorker
    )
    let mockPresenter = MockToDoPresenter(
      presentFetchToDoValidationClosure: {
        XCTAssert($0 == EditToDoSceneTestData.Interactor.fetchedToDo)
        XCTAssertNil($1)
      }
    )
    interactor.presenter = mockPresenter
    interactor.toDoId = EditToDoSceneTestData.Interactor.toDoId
    let request = EditToDo.FetchToDo.Request()

    interactor.fetchToDo(request: request)

    let fetchedToDo = try XCTUnwrap(interactor.toDo)
    XCTAssertEqual(fetchedToDo, EditToDoSceneTestData.Interactor.toDo)
  }

  func test_투두_아이디가_없으면_투두_조회를_실패하는가() throws {
    let mockToDoWorker = MockToDoWorker()
    let mockGroupWorker = MockGroupWorker()
    let interactor = EditToDoInteractor(
      toDoWorker: mockToDoWorker,
      groupWorker: mockGroupWorker
    )
    let mockPresenter = MockToDoPresenter(
      presentFetchToDoValidationClosure: {
        XCTAssertNil($0)
        XCTAssert($1 as? EditToDoInteractorError == .toDoDataNotExisted)
      }
    )
    interactor.presenter = mockPresenter
    let request = EditToDo.FetchToDo.Request()

    interactor.fetchToDo(request: request)

    XCTAssertNil(interactor.toDo)
  }

  func test_투두가_존재하면_투두를_성공적으로_수정하는가() throws {
    let mockToDoWorker = MockToDoWorker(
      editToDoValidationClosure: {
        XCTAssert($0.name == EditToDoSceneTestData.Interactor.toDoNameForEdit)
        XCTAssert($0.groupData == EditToDoSceneTestData.Interactor.groupForEdit)
      }
    )
    let mockGroupWorker = MockGroupWorker()
    let interactor = EditToDoInteractor(
      toDoWorker: mockToDoWorker,
      groupWorker: mockGroupWorker
    )
    let mockPresenter = MockToDoPresenter(
      presentEditResultValidationClosure: { XCTAssertNil($0) }
    )
    interactor.presenter = mockPresenter
    interactor.toDo = EditToDoSceneTestData.Interactor.toDo
    let groupForEdit = EditToDoSceneTestData.Interactor.groupForEdit
    let request = EditToDo.CompleteEditToDo.Request(
      toDoName: EditToDoSceneTestData.Interactor.toDoNameForEdit,
      displayedGroup: EditToDo.CompleteEditToDo.Request.DisplayedGroup(
        id: groupForEdit.id, name: groupForEdit.name, color: groupForEdit.color
      )
    )

    interactor.editToDo(request: request)
  }

  func test_투두가_존재하지_않으면_투두_수정을_실패하는가() throws {
    let mockToDoWorker = MockToDoWorker()
    let mockGroupWorker = MockGroupWorker()
    let interactor = EditToDoInteractor(
      toDoWorker: mockToDoWorker,
      groupWorker: mockGroupWorker
    )
    let mockPresenter = MockToDoPresenter(
      presentEditResultValidationClosure: {
        XCTAssert($0 as? EditToDoInteractorError == .toDoDataNotExisted)
      }
    )
    interactor.presenter = mockPresenter
    let group = EditToDoSceneTestData.Interactor.groupForEdit
    let request = EditToDo.CompleteEditToDo.Request(
      toDoName: EditToDoSceneTestData.Interactor.toDoNameForEdit,
      displayedGroup: EditToDo.CompleteEditToDo.Request.DisplayedGroup(
        id: group.id, name: group.name, color: group.color
      )
    )

    interactor.editToDo(request: request)
  }

  func test_투두_아이디가_존재하면_투두를_성공적으로_삭제하는가() throws {
    let mockToDoWorker = MockToDoWorker()
    let mockGroupWorker = MockGroupWorker()
    let interactor = EditToDoInteractor(
      toDoWorker: mockToDoWorker,
      groupWorker: mockGroupWorker
    )
    let mockPresenter = MockToDoPresenter(
      presentDeleteResultValidationClosure: { XCTAssertNil($0) }
    )
    interactor.presenter = mockPresenter
    interactor.toDoId = EditToDoSceneTestData.Interactor.toDoId
    let request = EditToDo.DeleteToDo.Request()

    interactor.deleteToDo(request: request)
  }

  func test_투두_아이디가_존재하지_않으면_투두_삭제를_실패하는가() throws {
    let mockToDoWorker = MockToDoWorker()
    let mockGroupWorker = MockGroupWorker()
    let interactor = EditToDoInteractor(
      toDoWorker: mockToDoWorker,
      groupWorker: mockGroupWorker
    )
    let mockPresenter = MockToDoPresenter(
      presentDeleteResultValidationClosure: {
        XCTAssert($0 as? EditToDoInteractorError == .toDoDataNotExisted)
      }
    )
    interactor.presenter = mockPresenter
    let request = EditToDo.DeleteToDo.Request()

    interactor.deleteToDo(request: request)
  }

  func test_투두_알림을_활성화하면_정상적으로_변경되는가() throws {
    let mockToDoWorker = MockToDoWorker()
    let mockGroupWorker = MockGroupWorker()
    let interactor = EditToDoInteractor(
      toDoWorker: mockToDoWorker,
      groupWorker: mockGroupWorker
    )
    let mockPresenter = MockToDoPresenter(
      presentChangeAlarmValidationClosure: {
        XCTAssert($0 == true)
      }
    )
    var toDo = EditToDoSceneTestData.Interactor.toDo
    toDo.alarm.isAlarmOn = false
    interactor.toDo = EditToDoSceneTestData.Interactor.toDo
    interactor.presenter = mockPresenter
    let request = EditToDo.ChangeAlarmActivation.Request()

    interactor.changeAlarmActivation(request: request)

    let toDoOfInteractor = try XCTUnwrap(interactor.toDo)
    XCTAssert(toDoOfInteractor.alarm.isAlarmOn == true)
  }

  func test_투두를_매일_반복하도록_설정하면_정상적으로_반영되는가() throws {
    let mockToDoWorker = MockToDoWorker()
    let mockGroupWorker = MockGroupWorker()
    let interactor = EditToDoInteractor(
      toDoWorker: mockToDoWorker,
      groupWorker: mockGroupWorker
    )
    let mockPresenter = MockToDoPresenter(
      presentRepetitionValidationClosure: {
        XCTAssert($0 == .repeatEveryday)
      }
    )
    interactor.toDo = EditToDoSceneTestData.Interactor.toDo
    interactor.presenter = mockPresenter
    let request = EditToDo.ChangeRepetition.Request(isOnlyToday: false, isEveryday: true)

    interactor.changeReptition(request: request)

    let toDoOfInteractor = try XCTUnwrap(interactor.toDo)
    XCTAssert(toDoOfInteractor.repetition.isRepeatEveryday == true)
  }

  func test_투두를_오늘만_반복하도록_설정하면_정상적으로_반영되는가() throws {
    let mockToDoWorker = MockToDoWorker()
    let mockGroupWorker = MockGroupWorker()
    let interactor = EditToDoInteractor(
      toDoWorker: mockToDoWorker,
      groupWorker: mockGroupWorker
    )
    let mockPresenter = MockToDoPresenter(
      presentRepetitionValidationClosure: {
        XCTAssert($0 == .repeatOnlyToday)
      }
    )
    interactor.toDo = EditToDoSceneTestData.Interactor.toDo
    interactor.presenter = mockPresenter
    let request = EditToDo.ChangeRepetition.Request(isOnlyToday: true, isEveryday: nil)

    interactor.changeReptition(request: request)

    let toDoOfInteractor = try XCTUnwrap(interactor.toDo)
    XCTAssert(toDoOfInteractor.repetition.isOnlyToday == true)
  }

  func test_투두를_일정_기간동안_반복하도록_설정하면_정상적으로_반영되는가() throws {
    let mockToDoWorker = MockToDoWorker()
    let mockGroupWorker = MockGroupWorker()
    let interactor = EditToDoInteractor(
      toDoWorker: mockToDoWorker,
      groupWorker: mockGroupWorker
    )
    let mockPresenter = MockToDoPresenter(
      presentRepetitionValidationClosure: {
        XCTAssert($0 == .repeatInRange)
      }
    )
    interactor.toDo = EditToDoSceneTestData.Interactor.toDo
    interactor.presenter = mockPresenter
    let request = EditToDo.ChangeRepetition.Request(isOnlyToday: false, isEveryday: false)

    interactor.changeReptition(request: request)

    let toDoOfInteractor = try XCTUnwrap(interactor.toDo)
    XCTAssert(toDoOfInteractor.repetition.isRepeatEveryday == false)
  }
}

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
}

struct MockToDoWorker: ToDoWorkLogic {
  var editToDoValidationClosure: ((_ toDoForEdit: EditToDo.ToDo) -> Void)?

  init(
    editToDoValidationClosure: ((
      _ toDoForEdit: EditToDo.ToDo
    ) -> Void)? = { _ in XCTFail("editToDo unexpectedly called") }
  ) {
    self.editToDoValidationClosure = editToDoValidationClosure
  }

  func fetchToDo(id: Int?) throws -> EditToDoSceneEntity.EditToDo.ToDo {
    return EditToDoSceneTestData.Interactor.toDo
  }

  func deleteToDo(id: Int?) throws {

  }

  func editToDo(_ toDo: EditToDoSceneEntity.EditToDo.ToDo) throws {
    self.editToDoValidationClosure?(toDo)
  }
}

struct MockGroupWorker: GroupWorkLogic {
  func fetchGroupList() throws -> [EditToDoSceneEntity.EditToDo.Group] {
    return EditToDoSceneTestData.Interactor.groupList
  }
}
