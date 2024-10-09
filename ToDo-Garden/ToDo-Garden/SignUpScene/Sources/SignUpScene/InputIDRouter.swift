//
//  InputIDRouter.swift
//  
//
//  Created by SONG on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import InputIDSceneAPI

protocol InputIDRoutingLogic {
  func routeToSomewhere()
}

protocol InputIDDataPassing {
  var dataStore: InputIDDataStore? { get }
}

class InputIDRouter: InputIDDataPassing {
  weak var viewController: InputIDViewController?
  var dataStore: InputIDDataStore?
  private let nextSceneBuilder: NextSceneBuildable
  
  init(nextSceneBuilder: NextSceneBuildable) {
    self.nextSceneBuilder = nextSceneBuilder
  }
}

// MARK: - Routing

extension InputIDRouter: InputIDRoutingLogic {
  func routeToSomewhere() {
    let destinationViewController = self.nextSceneBuilder.build(with: NextScenePayload())
    
    self.viewController?.present(destinationViewController, animated: true)
  }
}

// MARK: - Declare Payload for scene

extension InputIDRouter {
  struct NextScenePayload: NextScenePayloadable {
    // var name: String
  }
}
