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
    self.interactor = ManageGroupInteractor(worker: mockWorker)
    self.mockPresenter = MockManageGroupPresenter()
    self.interactor.presenter = self.mockPresenter
  }
  
  // MARK: Tests
  func testFetchGroupList() async {
    // Given
    let expectedGroups = ManageGroupMockData.fetchedData
    self.mockWorker.fetchGroupListResult = .success(expectedGroups)
    
    // When
    await self.interactor.fetchGroupList(request: ManageGroup.FetchGroupList.Request())
    
    // Then
    XCTAssertEqual(self.interactor.currentGroups, expectedGroups)
    XCTAssertTrue(self.mockPresenter.presentFetchedGroupListCalled)
    XCTAssertEqual(self.mockPresenter.fetchedGroupListResponse?.data, expectedGroups)
  }
  
  func testSaveGroupList() async {
    // Given
    let groupsToSave = [
      ManageGroup.ToDoGroup(id: "1", groupName: "Group1", progressColor: .red, progressRate: 0.5)
    ]
    let request = ManageGroup.SaveGroupList.Request(with: groupsToSave)
    self.mockWorker.saveGroupListResult = .success(groupsToSave)
    
    // When
    await self.interactor.saveGroupList(request: request)
    
    // Then
    XCTAssertEqual(self.interactor.currentGroups, groupsToSave)
    XCTAssertTrue(self.mockPresenter.presentSavedGroupListCalled)
    XCTAssertEqual(self.mockPresenter.savedGroupListResponse?.data, groupsToSave)
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
    XCTAssertTrue(self.mockPresenter.presentDeletedGroupCalled)
    XCTAssertEqual(self.mockPresenter.deletedGroupResponse?.id, "1")
    XCTAssertEqual(self.mockPresenter.deletedGroupResponse?.index, 0)
  }
}

// MARK: - Mock
extension ManageGroupInteractorTests {
  class MockManageGroupPresenter: ManageGroupPresentationLogic {
    var presentFetchedGroupListCalled = false
    var presentSavedGroupListCalled = false
    var presentDeletedGroupCalled = false
    
    var fetchedGroupListResponse: ManageGroup.FetchGroupList.Response?
    var savedGroupListResponse: ManageGroup.SaveGroupList.Response?
    var deletedGroupResponse: ManageGroup.DeleteGroup.Response?
    
    func presentFetchedGroupList(response: ManageGroup.FetchGroupList.Response) {
      self.presentFetchedGroupListCalled = true
      self.fetchedGroupListResponse = response
    }
    
    func presentSavedGroupList(response: ManageGroup.SaveGroupList.Response) {
      self.presentSavedGroupListCalled = true
      self.savedGroupListResponse = response
    }
    
    func presentDeletedGroup(response: ManageGroup.DeleteGroup.Response) {
      self.presentDeletedGroupCalled = true
      self.deletedGroupResponse = response
    }
  }
  
  class MockWorker: ManageGroupWorkable {
    var fetchGroupListResult: Result<[ManageGroup.ToDoGroup], Error>?
    var saveGroupListResult: Result<[ManageGroup.ToDoGroup], Error>?
    
    func fetchGroupList(request: ManageGroup.FetchGroupList.Request) async -> Result<[ManageGroup.ToDoGroup], Error> {
      return self.fetchGroupListResult ?? .failure(NSError(domain: "Test", code: 0, userInfo: nil))
    }
    
    func saveGroupList(request: ManageGroup.SaveGroupList.Request) async -> Result<[ManageGroup.ToDoGroup], Error> {
      return self.saveGroupListResult ?? .failure(NSError(domain: "Test", code: 0, userInfo: nil))
    }
  }
}
