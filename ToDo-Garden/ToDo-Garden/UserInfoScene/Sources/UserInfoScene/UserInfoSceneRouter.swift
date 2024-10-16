//
//  UserInfoSceneRouter.swift
//  
//
//  Created by Wood on 8/28/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import EditUserIntroductionSceneAPI
import UserInfoSceneAPI

protocol UserInfoSceneRoutingLogic {
  func routeToLoginScene()
}

protocol UserInfoSceneDataPassing {
  var dataStore: UserInfoSceneDataStore? { get }
}

class UserInfoSceneRouter: UserInfoSceneDataPassing {
  weak var viewController: UserInfoSceneViewController?
  var dataStore: UserInfoSceneDataStore?
  private let editUserIntroductionSceneBuilder: EditUserIntroductionSceneBuildable?

  init(editUserIntroductionSceneBuilder: EditUserIntroductionSceneBuildable?) {
    self.editUserIntroductionSceneBuilder = editUserIntroductionSceneBuilder
  }
}

// MARK: - Routing

extension UserInfoSceneRouter: UserInfoSceneRoutingLogic {
  func routeToLoginScene() {
    // TODO: LoginSceneBuilder가 구현되면 해당 화면으로 라우팅할 예정입니다.
  }
}

// MARK: - Declare Payload for scene

extension UserInfoSceneRouter {
  struct NextScenePayload: NextScenePayloadable {
    // var name: String
  }
}
