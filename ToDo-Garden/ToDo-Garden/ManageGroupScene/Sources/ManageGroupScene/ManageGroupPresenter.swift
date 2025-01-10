//
//  ManageGroupPresenter.swift
//  
//
//  Created by SONG on 6/26/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit.UIColor

import ManageGroupSceneEntity

@MainActor
protocol ManageGroupPresentationLogic {
  func presentFetchedGroupList(response: ManageGroup.FetchGroupList.Response)
  func presentSavedGroupList(response: ManageGroup.SaveGroupList.Response)
  func presentDeletedGroup(response: ManageGroup.DeleteGroup.Response)
  func presentAddedGroup(response: ManageGroup.AddGroup.Response)
  func presentEditedGroup(response: ManageGroup.EditGroup.Response)
  func presentFailedToSaveGroupList()
}

class ManageGroupPresenter {
  weak var viewController: ManageGroupDisplayLogic?
}

// MARK: - Request to ViewController

extension ManageGroupPresenter: ManageGroupPresentationLogic {
  func presentFetchedGroupList(response: ManageGroup.FetchGroupList.Response) {
    let viewModel = ManageGroup.FetchGroupList.ViewModel(with: response.data)
    self.viewController?.displayFetchedGroupList(viewModel: viewModel)
  }
  
  func presentSavedGroupList(response: ManageGroup.SaveGroupList.Response) {
    let viewModel = ManageGroup.SaveGroupList.ViewModel(with: response.data)
    self.viewController?.displaySavedGroupList(viewModel: viewModel)
  }
  
  func presentDeletedGroup(response: ManageGroup.DeleteGroup.Response) {
    let viewModel = ManageGroup.DeleteGroup.ViewModel(
      groupID: response.groupID,
      index: response.index
    )
    self.viewController?.displayDeletedGroup(viewModel: viewModel)
  }
  
  func presentAddedGroup(response: ManageGroup.AddGroup.Response) {
    let viewModel = ManageGroup.AddGroup.ViewModel(group: response.group)
    self.viewController?.displayAddedGroup(viewModel: viewModel)
  }
  
  func presentEditedGroup(response: ManageGroup.EditGroup.Response) {
    let viewModel = ManageGroup.EditGroup.ViewModel(group: response.group, editedIndex: response.editedIndex)
    self.viewController?.displayEditedGroup(viewModel: viewModel)
  }
  
  func presentFailedToSaveGroupList() {
    self.viewController?.displayFailToSaveGroupList()
  }
}
