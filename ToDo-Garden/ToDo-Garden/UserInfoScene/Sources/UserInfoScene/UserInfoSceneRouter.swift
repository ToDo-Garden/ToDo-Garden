//
//  UserInfoSceneRouter.swift
//  
//
//  Created by Wood on 8/28/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import EditUserIntroductionSceneAPI
import EditUserNameSceneAPI
import UserInfoSceneAPI

protocol UserInfoSceneRoutingLogic {
  func routeToLoginScene()
  func routeToEditUserIntroductionScene()
  func routeToEditUserNameScene()
}

protocol UserInfoSceneDataPassing {
  var dataStore: UserInfoSceneDataStore? { get }
}

class UserInfoSceneRouter: UserInfoSceneDataPassing {
  weak var viewController: UserInfoSceneViewController?
  var dataStore: UserInfoSceneDataStore?
  private let editUserIntroductionSceneBuilder: EditUserIntroductionSceneBuildable?
  private let editUserNameSceneBuilder: EditUserNameSceneSceneBuildable?

  init(
    editUserIntroductionSceneBuilder: EditUserIntroductionSceneBuildable?,
    editUserNameSceneBuilder: EditUserNameSceneSceneBuildable?
  ) {
    self.editUserIntroductionSceneBuilder = editUserIntroductionSceneBuilder
    self.editUserNameSceneBuilder = editUserNameSceneBuilder
  }
}

// MARK: - Routing

extension UserInfoSceneRouter: UserInfoSceneRoutingLogic {
  func routeToLoginScene() {
    // TODO: LoginSceneBuilder가 구현되면 해당 화면으로 라우팅할 예정입니다.
  }

  func routeToEditUserNameScene() {
    guard let userName = self.dataStore?.userName,
      let editUserNameScene = self.editUserNameSceneBuilder?.build(
        with: EditUserNameScenePayload(userName: userName, delegate: self.viewController)
    ) else { return }

    self.viewController?.navigationController?.pushViewController(
      editUserNameScene,
      animated: true
    )
  }

  func routeToEditUserIntroductionScene() {
    guard let editUserIntroductionScene = self.editUserIntroductionSceneBuilder?.build(
      with: EditUserIntroductionScenePayload(
        userIntroduction: self.dataStore?.userIntroduction,
        delegate: self.viewController
      )
    ) else { return }

    self.viewController?.navigationController?.pushViewController(
      editUserIntroductionScene,
      animated: true
    )
  }
}

// MARK: - Declare Payload for scene

extension UserInfoSceneRouter {
  struct EditUserIntroductionScenePayload: EditUserIntroductionScenePayloadable {
    let userIntroduction: String?
    let delegate: EditUserIntroductionDelegate?
  }

  struct EditUserNameScenePayload: EditUserNameScenePayloadable {
    let userName: String
    var delegate: EditUserNameDelegate?
  }
}
