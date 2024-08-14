//
//  File.swift
//  
//
//  Created by Wood on 8/12/24.
//

import XCTest

@testable import EditToDoScene
@testable import EditToDoSceneAPI

class EditToDoSceneBuilderTests: XCTestCase {
  func test_EditToDoSceneBuilder가_투두_아이디를_Interactor에_성공적으로_전달하는가() throws {
    let dependency = EditToDoSceneBuilder.Dependency(
      someWorker: EditToDoWorker(),
      toDoWorker: MockToDoWorker(),
      groupWorker: MockGroupWorker()
    )
    let builder = EditToDoSceneBuilder(dependency: dependency)
    let payload = MockPayload(toDoId: EditToDoSceneTestData.Interactor.toDoId)

    let viewControllable = builder.build(with: payload)

    let viewController = viewControllable as? EditToDoViewController
    let payloadedToDoId = try XCTUnwrap(viewController?.router?.dataStore?.toDoId)
    XCTAssertEqual(payloadedToDoId, EditToDoSceneTestData.Interactor.toDoId)
  }
}

extension EditToDoSceneBuilderTests {
  struct MockPayload: EditToDoScenePayloadable {
    var toDoId: Int
  }
}
