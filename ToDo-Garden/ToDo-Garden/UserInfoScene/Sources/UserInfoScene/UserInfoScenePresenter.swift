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
  func presentSettingAppAlsert()
}

class UserInfoScenePresenter {
  weak var viewController: UserInfoSceneDisplayLogic?
}

// MARK: - Request to ViewController

extension UserInfoScenePresenter: UserInfoScenePresentationLogic {
  func presentSettingAppAlsert() {
    self.viewController?.displaySettingAppAlert()
  }
  
  func presentSomething(response: UserInfoScene.Something.Response) {
    let viewModel = UserInfoScene.Something.ViewModel()
    self.viewController?.displaySomething(viewModel: viewModel)
  }
}
