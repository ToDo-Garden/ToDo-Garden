//
//  LoginRouter.swift
//  
//
//  Created by SONG on 10/2/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import LoginSceneAPI

protocol LoginRoutingLogic {
  func routeToSignUpScene(
    userIdentifier: String,
    userEmailAddress: String?,
    agreeOptionalCondition: Bool
  )
}

protocol LoginDataPassing {
  var dataStore: LoginDataStore? { get }
}

class LoginRouter: LoginDataPassing {
  weak var viewController: LoginViewController?
  var dataStore: LoginDataStore?
  private let nextSceneBuilder: NextSceneBuildable
  
  init(nextSceneBuilder: NextSceneBuildable) {
    self.nextSceneBuilder = nextSceneBuilder
  }
}

// MARK: - Routing

extension LoginRouter: LoginRoutingLogic {
  func routeToSignUpScene(
    userIdentifier: String,
    userEmailAddress: String?,
    agreeOptionalCondition: Bool
  ) {
  }
}

// MARK: - Declare Payload for scene

extension LoginRouter {
  struct NextScenePayload: NextScenePayloadable {
    // var name: String
  }
}
