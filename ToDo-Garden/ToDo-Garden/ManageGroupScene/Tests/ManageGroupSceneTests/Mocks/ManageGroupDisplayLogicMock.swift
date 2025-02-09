//
//  ManageGroupDisplayLogicMock.swift
//  ManageGroupScene
//
//  Created by SONG on 2/8/25.
//

import UIKit

@testable import ManageGroupScene
import ManageGroupSceneAPI
import ManageGroupSceneEntity

final class ManageGroupDisplayLogicMock: ManageGroupDisplayLogic {
  
  var currentGroups: [ManageGroupSceneEntity.ManageGroup.ToDoGroup] = []
  
  func displayFetchedGroupList(viewModel: ManageGroupSceneEntity.ManageGroup.FetchGroupList.ViewModel) {
    self.currentGroups = viewModel.list
  }
  
  func displaySavedGroupList(viewModel: ManageGroupSceneEntity.ManageGroup.SaveGroupList.ViewModel) {
    self.currentGroups = viewModel.list
  }
  
  func displayDeletedGroup(viewModel: ManageGroupSceneEntity.ManageGroup.DeleteGroup.ViewModel) {
    self.currentGroups.remove(at: viewModel.index)
  }
  
  func displayAddedGroup(viewModel: ManageGroupSceneEntity.ManageGroup.AddGroup.ViewModel) {
    self.currentGroups.append(viewModel.group)
  }
  
  func displayEditedGroup(viewModel: ManageGroupSceneEntity.ManageGroup.EditGroup.ViewModel) {
    if let index = self.currentGroups.firstIndex(where: { $0.groupID == viewModel.group.groupID }) {
      self.currentGroups[index] = viewModel.group
    }
  }
  
  func displayFailToSaveGroupList() {
    return
  }
}

extension ManageGroupDisplayLogicMock {
  static let initialList = [
    ManageGroupSceneEntity.ManageGroup.ToDoGroup(
      groupID: UUID(),
      groupName: "TestGroupName1",
      progressColor: UIColor.red,
      progressRate: 0.5
    ),
    ManageGroupSceneEntity.ManageGroup.ToDoGroup(
      groupID: UUID(),
      groupName: "TestGroupName2",
      progressColor: UIColor.blue,
      progressRate: 0.25
    ),
    ManageGroupSceneEntity.ManageGroup.ToDoGroup(
      groupID: UUID(),
      groupName: "TestGroupName3",
      progressColor: UIColor.green,
      progressRate: 0.8
    )
  ]
  func reset() {
    self.currentGroups = ManageGroupDisplayLogicMock.initialList
  }
}
