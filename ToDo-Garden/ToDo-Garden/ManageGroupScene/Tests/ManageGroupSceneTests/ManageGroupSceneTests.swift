//
//  ManageGroupSceneTests.swift
//
//
//  Created by SONG on 9/10/24.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.

// swiftlint:disable all
import UIKit
import Testing

@testable import ManageGroupScene
import ManageGroupSceneAPI
import ManageGroupSceneEntity
import PostGroupSceneEntity

@MainActor
private final class ManageGroupSceneTests {
  private var worker: ManageGroupWorkerStub
  private var destination: ManageGroupDisplayLogicMock
  
  private var viewController: ManageGroupViewController
  private var interactor: ManageGroupInteractor
  private var presenter: ManageGroupPresenter
  
  init() {
    self.worker = ManageGroupWorkerStub()
    self.destination = ManageGroupDisplayLogicMock()
    self.destination.reset()
    
    self.viewController = ManageGroupViewController()
    self.interactor = ManageGroupInteractor(worker: self.worker)
    self.presenter = ManageGroupPresenter()
    self.congiureVIP()
  }
  
  @Test func testFetchGroupList() async {
    self.reset()
    self.worker.setFetchedGroupList(ManageGroupMockData.fetchedData)
    self.viewController.fetchGroupList()
    await self.wait()
    #expect(self.destination.currentGroups == ManageGroupMockData.fetchedData)
  }
  
  @Test func testAddGroup() {
    self.reset()
    let expectedGroupID = UUID()
    let expectedGroupName = expectedGroupID.uuidString
    let expectedColor = UIColor.cyan
    let expectedGroup = ManageGroup.ToDoGroup(
      groupID: expectedGroupID,
      groupName: expectedGroupName,
      progressColor: expectedColor,
      progressRate: 0.0
    )
    
    let expectedGroupList: [ManageGroup.ToDoGroup] = {
      var expected = ManageGroupDisplayLogicMock.initialList
      expected.append(expectedGroup)
      return expected
    }()
    
    self.worker.setAddedGroup(expectedGroup)
    self.viewController.groupListTableView.isEditing = true
    self.viewController.addGroup(
      group:
        PostGroup.ToDoGroup(
          groupID: expectedGroupID,
          groupName: expectedGroupName,
          groupColor: expectedColor
        )
    )
    #expect(self.destination.currentGroups.last?.groupID == expectedGroupID)
    #expect(self.destination.currentGroups.last?.groupName == expectedGroupName)
    #expect(self.destination.currentGroups.last?.progressColor == expectedColor)
    #expect(self.destination.currentGroups.last?.progressRate == 0.0)
    #expect(self.destination.currentGroups == expectedGroupList)
  }
  
  @Test func testEditGroup() {
    self.reset()
    let expectedGroupID = ManageGroupDisplayLogicMock.initialList.randomElement()!.groupID
    let expectedGroupName = expectedGroupID.uuidString
    let expectedColor = UIColor.red
    let expectedGroup = ManageGroup.ToDoGroup(
      groupID: expectedGroupID,
      groupName: expectedGroupName,
      progressColor: expectedColor,
      progressRate: 0.0
    )
    
    self.worker.setEditedGroup(expectedGroup)
    self.viewController.editGroup(
      group: PostGroup.ToDoGroup(
        groupID: expectedGroupID,
        groupName: expectedGroupName,
        groupColor: expectedColor
      )
    )
    
    #expect(self.destination.currentGroups.contains { $0.groupID == expectedGroupID })
    #expect(self.destination.currentGroups.contains { $0.groupName != expectedGroupName })
  }
  
  @Test func testDirectAddGroup() async {
    self.reset()
    let expectedGroupID = UUID()
    let expectedGroupName = expectedGroupID.uuidString
    let expectedColor = UIColor.cyan
    let expectedGroup = ManageGroup.ToDoGroup(
      groupID: expectedGroupID,
      groupName: expectedGroupName,
      progressColor: expectedColor,
      progressRate: 0.0
    )
    let expectedGroupList: [ManageGroup.ToDoGroup] = {
      var expected = ManageGroupDisplayLogicMock.initialList
      expected.append(expectedGroup)
      return expected
    }()
    
    self.viewController.groupListTableView.isEditing = false
    self.worker.setDirectAddedGroupID(expectedGroupID)
    self.viewController.addGroup(
      group: PostGroup.ToDoGroup(
        groupID: expectedGroup.groupID,
        groupName: expectedGroup.groupName,
        groupColor: expectedGroup.progressColor
      )
    )
    await self.wait()
    #expect(self.destination.currentGroups == expectedGroupList)
  }
  
  @Test func testDeleteGroup() {
    self.reset()
    let expectedGroupID = ManageGroupDisplayLogicMock.initialList.randomElement()!.groupID
    let expectedIndex = ManageGroupDisplayLogicMock.initialList.firstIndex(where: { $0.groupID == expectedGroupID })!
    self.viewController.deleteGroup(groupID: expectedGroupID, index: expectedIndex)
    #expect(self.destination.currentGroups.contains(where: { $0.groupID == expectedGroupID }) == false)
  }
  
  @Test func testSaveGroups() async {
    self.reset()
    let expectedGroupList = ManageGroupMockData.fetchedData
    self.interactor.currentGroups = expectedGroupList
    self.worker.setSaveGroupList(expectedGroupList)
    self.viewController.saveGroupList()
    await self.wait()
    #expect(self.destination.currentGroups == expectedGroupList)
  }
  
  @Test func testCancelEditing() {
    self.reset()
    let editted = ManageGroupMockData.fetchedData
    let expectedGroupList = ManageGroupDisplayLogicMock.initialList
    self.interactor.currentGroups = editted
    self.viewController.cancelEditing()
    #expect(self.destination.currentGroups == expectedGroupList)
  }
}

extension ManageGroupSceneTests {
  private func reset() {
    self.worker.reset()
    self.destination.reset()
    self.resetInteractor()
  }
  
  private func resetInteractor() {
    self.interactor.currentGroups = ManageGroupDisplayLogicMock.initialList
  }
  
  private func congiureVIP() {
    self.viewController.interactor = self.interactor
    self.interactor.presenter = self.presenter
    self.presenter.viewController = self.destination
  }
  
  private func wait() async {
    do {
      try await Task.sleep(nanoseconds: 10000000)
    } catch {
      return
    }
  }
}
// swiftlint:enable all
