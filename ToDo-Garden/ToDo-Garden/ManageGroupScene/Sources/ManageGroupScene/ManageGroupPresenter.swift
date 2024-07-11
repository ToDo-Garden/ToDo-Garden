//
//  ManageGroupPresenter.swift
//  
//
//  Created by SONG on 6/26/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import ManageGroupSceneEntity

protocol ManageGroupPresentationLogic {
  func presentSomething(response: ManageGroup.FetchGroupList.Response)
}

class ManageGroupPresenter {
  weak var viewController: ManageGroupDisplayLogic?
}

// MARK: - Request to ViewController

extension ManageGroupPresenter: ManageGroupPresentationLogic {
  func presentSomething(response: ManageGroup.FetchGroupList.Response) {
    let viewModel = ManageGroup.FetchGroupList.ViewModel(with: [])
    self.viewController?.displaySomething(viewModel: viewModel)
  }
}
