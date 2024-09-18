//
//  ManageGroupInteractorTests.swift
//
//
//  Created by SONG on 9/10/24.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

import XCTest

@testable import ManageGroupScene
@testable import ManageGroupSceneAPI
@testable import ManageGroupSceneEntity

final class ManageGroupInteractorTests: XCTestCase {
  
  // MARK: Test Object
  var interactor: ManageGroupInteractor!
  var mockPresenter: MockManageGroupPresenter!
  var mockWorker: MockWorker!
  
  // MARK: Test lifecycle
  override func setUp() {
    super.setUp()
    self.setupManageGroupInteractor()
  }
  
  override func tearDown() {
    self.interactor = nil
    self.mockPresenter = nil
    self.mockWorker = nil
    super.tearDown()
  }
  
  // MARK: Test setup
  func setupManageGroupInteractor() {
    self.mockWorker = MockWorker()
    self.interactor = ManageGroupInteractor(worker: self.mockWorker)
    self.mockPresenter = MockManageGroupPresenter()
    self.interactor.presenter = self.mockPresenter
  }
  
  // MARK: Tests
  func testFetchGroupList() async {
    // Given
    let expectedGroups = ManageGroupMockData.fetchedData
    self.mockWorker.setFetchGroupListResultSuccess(groups: expectedGroups)
    
    // When
    await self.interactor.fetchGroupList(request: ManageGroup.FetchGroupList.Request())
    
    // Then
    XCTAssertEqual(self.interactor.currentGroups, expectedGroups)
    XCTAssertEqual(self.mockPresenter.presentedGroups, expectedGroups)
  }
  
  func testSaveGroupList() async {
    // Given
    let groupsToSave = [
      ManageGroup.ToDoGroup(id: "1", groupName: "Group1", progressColor: .red, progressRate: 0.5)
    ]
    let request = ManageGroup.SaveGroupList.Request(with: groupsToSave)
    self.mockWorker.setSaveGroupListResultSuccess(groups: groupsToSave)
    
    // When
    await self.interactor.saveGroupList(request: request)
    
    // Then
    XCTAssertEqual(self.interactor.currentGroups, groupsToSave)
    XCTAssertEqual(self.mockPresenter.presentedGroups, groupsToSave)
  }
  
  func testDeleteGroup() {
    // Given
    let groupToDelete = ManageGroup.ToDoGroup(id: "1", groupName: "Group1", progressColor: .red, progressRate: 0.5)
    self.interactor.currentGroups = [groupToDelete]
    let request = ManageGroup.DeleteGroup.Request(id: "1", index: 0)
    
    // When
    self.interactor.deleteGroup(request: request)
    
    // Then
    XCTAssertTrue(self.interactor.currentGroups.isEmpty)
    XCTAssertEqual(self.mockPresenter.deletedGroupId, "1")
    XCTAssertEqual(self.mockPresenter.deletedGroupIndex, 0)
  }
}

// MARK: - Mock
extension ManageGroupInteractorTests {
  class MockManageGroupPresenter: ManageGroupPresentationLogic {
    private(set) var presentedGroups: [ManageGroup.ToDoGroup]?
    private(set) var deletedGroupId: String?
    private(set) var deletedGroupIndex: Int?
    
    func presentFetchedGroupList(response: ManageGroup.FetchGroupList.Response) {
      self.presentedGroups = response.data
    }
    
    func presentSavedGroupList(response: ManageGroup.SaveGroupList.Response) {
      self.presentedGroups = response.data
    }
    
    func presentDeletedGroup(response: ManageGroup.DeleteGroup.Response) {
      self.deletedGroupId = response.id
      self.deletedGroupIndex = response.index
    }
  }
  
  class MockWorker: ManageGroupWorkable {
    private var fetchGroupListResult: Result<[ManageGroup.ToDoGroup], Error>?
    private var saveGroupListResult: Result<[ManageGroup.ToDoGroup], Error>?
    
    func setFetchGroupListResultSuccess(groups: [ManageGroup.ToDoGroup]) {
      self.fetchGroupListResult = .success(groups)
    }
    
    func setSaveGroupListResultSuccess(groups: [ManageGroup.ToDoGroup]) {
      self.saveGroupListResult = .success(groups)
    }
    
    func fetchGroupList(request: ManageGroup.FetchGroupList.Request) async -> Result<[ManageGroup.ToDoGroup], Error> {
      return self.fetchGroupListResult ?? .failure(NSError(domain: "Test", code: 0, userInfo: nil))
    }
    
    func saveGroupList(request: ManageGroup.SaveGroupList.Request) async -> Result<[ManageGroup.ToDoGroup], Error> {
      return self.saveGroupListResult ?? .failure(NSError(domain: "Test", code: 0, userInfo: nil))
    }
  }
}
