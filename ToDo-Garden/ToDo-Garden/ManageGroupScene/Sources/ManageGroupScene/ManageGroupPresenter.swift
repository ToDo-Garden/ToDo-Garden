//
//  ManageGroupPresenter.swift
//  
//
//  Created by SONG on 6/26/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit.UIColor

import ManageGroupSceneEntity

protocol ManageGroupPresentationLogic {
  func presentFetchedGroupList(response: ManageGroup.FetchGroupList.Response)
  func presentSaveGroupList(response: ManageGroup.SaveGroupList.Response)
  func presentDeletedGroup(response: ManageGroup.DeleteGroup.Response)
  func presentCancelEditingGroup()
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
  
  func presentSaveGroupList(response: ManageGroup.SaveGroupList.Response) {
    let viewModel = ManageGroup.SaveGroupList.ViewModel(with: response.data)
    self.viewController?.displaySavedGroupList(viewModel: viewModel)
  }
  
  func presentDeletedGroup(response: ManageGroup.DeleteGroup.Response) {
    let viewModel = ManageGroup.DeleteGroup.ViewModel(
      id: response.id,
      index: response.index
    )
    self.viewController?.displayDeletedGroup(viewModel: viewModel)
  }
  
  func presentCancelEditingGroup() {
    self.viewController?.displayCancelEditingGroup()
  }
}
