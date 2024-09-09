//
//  UserInfoScenePresenter.swift
//  
//
//  Created by Wood on 8/28/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import UserInfoSceneEntity

protocol UserInfoScenePresentationLogic {
  func presentSomething(response: UserInfoScene.Something.Response)
  func presentUserPhotoAccess(response: UserInfoScene.FetchUserPhotoAccess.Response)
}

class UserInfoScenePresenter {
  weak var viewController: UserInfoSceneDisplayLogic?
}

// MARK: - Request to ViewController

extension UserInfoScenePresenter: UserInfoScenePresentationLogic {
  func presentUserPhotoAccess(response: UserInfoScene.FetchUserPhotoAccess.Response) {
    let isPhotoAccessible = response.isPhotoAccessible
    let viewModel = UserInfoScene.FetchUserPhotoAccess.ViewModel(isPhotoAccessible: isPhotoAccessible)
    self.viewController?.displayUserPhotoAccess(viewModel: viewModel)
  }

  func presentSomething(response: UserInfoScene.Something.Response) {
    let viewModel = UserInfoScene.Something.ViewModel()
    self.viewController?.displaySomething(viewModel: viewModel)
  }
}
