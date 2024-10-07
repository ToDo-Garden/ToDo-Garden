//
//  EditUserIntroductionSceneRouter.swift
//  
//
//  Created by Wood on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

protocol EditUserIntroductionSceneRoutingLogic {
  func routeToSomewhere()
}

protocol EditUserIntroductionSceneDataPassing {
  var dataStore: EditUserIntroductionSceneDataStore? { get }
}

class EditUserIntroductionSceneRouter: EditUserIntroductionSceneDataPassing {
  weak var viewController: EditUserIntroductionSceneViewController?
  var dataStore: EditUserIntroductionSceneDataStore?
  private let nextSceneBuilder: NextSceneBuildable
  
  init(nextSceneBuilder: NextSceneBuildable) {
    self.nextSceneBuilder = nextSceneBuilder
  }
}

// MARK: - Routing

extension EditUserIntroductionSceneRouter: EditUserIntroductionSceneRoutingLogic {
  func routeToSomewhere() {
    let destinationViewController = self.nextSceneBuilder.build(with: NextScenePayload())
    
    self.viewController?.present(destinationViewController, animated: true)
  }
}

// MARK: - Declare Payload for scene

extension EditUserIntroductionSceneRouter {
  struct NextScenePayload: NextScenePayloadable {
    // var name: String
  }
}
