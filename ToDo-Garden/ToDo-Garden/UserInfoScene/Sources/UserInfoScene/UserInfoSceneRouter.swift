//
//  UserInfoSceneRouter.swift
//  
//
//  Created by Wood on 8/28/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import UserInfoSceneAPI

protocol UserInfoSceneRoutingLogic {
}

protocol UserInfoSceneDataPassing {
  var dataStore: UserInfoSceneDataStore? { get }
}

class UserInfoSceneRouter: UserInfoSceneDataPassing {
  weak var viewController: UserInfoSceneViewController?
  var dataStore: UserInfoSceneDataStore?
  private let nextSceneBuilder: NextSceneBuildable?

  init(nextSceneBuilder: NextSceneBuildable?) {
    self.nextSceneBuilder = nextSceneBuilder
  }
}

// MARK: - Routing

extension UserInfoSceneRouter: UserInfoSceneRoutingLogic {
}

// MARK: - Declare Payload for scene

extension UserInfoSceneRouter {
  struct NextScenePayload: NextScenePayloadable {
    // var name: String
  }
}
