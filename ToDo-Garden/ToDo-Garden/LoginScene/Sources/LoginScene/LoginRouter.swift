//
//  LoginRouter.swift
//
//
//  Created by SONG on 10/2/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import LoginSceneAPI
import SignUpSceneAPI

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
  private let signUpSceneBuilder: SignUpSceneBuildable
  
  init(signUpSceneBuilder: SignUpSceneBuildable) {
    self.signUpSceneBuilder = signUpSceneBuilder
  }
}

// MARK: - Routing

extension LoginRouter: LoginRoutingLogic {
  func routeToSignUpScene(
    userIdentifier: String,
    userEmailAddress: String?,
    agreeOptionalCondition: Bool
  ) {
    let destinationViewController = self.signUpSceneBuilder.build(
      with: SignUpScenePayload(
        userIdentifier: userIdentifier,
        userEmailAddress: userEmailAddress,
        agreeOptionalCondition: agreeOptionalCondition
      )
    )
    self.viewController?.navigationController?.navigationBar.isHidden = false
    self.viewController?.navigationController?.pushViewController(destinationViewController, animated: true)
  }
}

// MARK: - Declare Payload for scene
// MARK: - 변경 가능성 있음
extension LoginRouter {
  struct SignUpScenePayload: SignUpScenePayloadable {
    var userIdentifier: String
    var userEmailAddress: String?
    var agreeOptionalCondition: Bool
  }
}
