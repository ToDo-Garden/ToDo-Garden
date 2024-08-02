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
  func presentDeletedGroup(response: ManageGroup.DeleteGroup.Response)
  func presentReorderedGroup(response: ManageGroup.ReorderGroup.Response)
}

class ManageGroupPresenter {
  weak var viewController: ManageGroupDisplayLogic?
  private let fetchedData: [ManageGroup.ToDoGroup] = ManageGroupMockData.fetchedData
}

// MARK: - Request to ViewController

extension ManageGroupPresenter: ManageGroupPresentationLogic {
  func presentFetchedGroupList(response: ManageGroup.FetchGroupList.Response) {
    let todoGroup = self.fetchedData
    let viewModel = ManageGroup.FetchGroupList.ViewModel(with: todoGroup)
    self.viewController?.displayFetchedGroupList(viewModel: viewModel)
  }
  
  func presentDeletedGroup(response: ManageGroup.DeleteGroup.Response) {
  }
  
  func presentReorderedGroup(response: ManageGroup.ReorderGroup.Response) {
  }
}
