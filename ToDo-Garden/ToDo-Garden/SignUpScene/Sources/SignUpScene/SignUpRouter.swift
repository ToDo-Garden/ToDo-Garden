//
//  SignUpRouter.swift
//  
//
//  Created by SONG on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SignUpSceneAPI

protocol SignUpRoutingLogic {
  func routeToSomewhere()
}

protocol SignUpDataPassing {
  var dataStore: SignUpDataStore? { get }
}

class SignUpRouter: SignUpDataPassing {
  weak var viewController: SignUpViewController?
  var dataStore: SignUpDataStore?
  private let nextSceneBuilder: NextSceneBuildable
  
  init(nextSceneBuilder: NextSceneBuildable) {
    self.nextSceneBuilder = nextSceneBuilder
  }
}

// MARK: - Routing

extension SignUpRouter: SignUpRoutingLogic {
  func routeToSomewhere() {
    let destinationViewController = self.nextSceneBuilder.build(with: NextScenePayload())
    
    self.viewController?.present(destinationViewController, animated: true)
  }
}

// MARK: - Declare Payload for scene

extension SignUpRouter {
  struct NextScenePayload: NextScenePayloadable {
    // var name: String
  }
}
