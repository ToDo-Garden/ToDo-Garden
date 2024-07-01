//
//  EditToDoRouter.swift
//  
//
//  Created by Wood on 6/29/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import EditToDoSceneAPI

protocol EditToDoRoutingLogic {
  func routeToSomewhere()
}

protocol EditToDoDataPassing {
  var dataStore: EditToDoDataStore? { get }
}

class EditToDoRouter: EditToDoDataPassing {
  weak var viewController: EditToDoViewController?
  var dataStore: EditToDoDataStore?
  private let nextSceneBuilder: NextSceneBuildable
  
  init(nextSceneBuilder: NextSceneBuildable) {
    self.nextSceneBuilder = nextSceneBuilder
  }
}

// MARK: - Routing

extension EditToDoRouter: EditToDoRoutingLogic {
  func routeToSomewhere() {
    let destinationViewController = self.nextSceneBuilder.build(with: NextScenePayload())
    
    self.viewController?.present(destinationViewController, animated: true)
  }
}

// MARK: - Declare Payload for scene

extension EditToDoRouter {
  struct NextScenePayload: NextScenePayloadable {
    // var name: String
  }
}
