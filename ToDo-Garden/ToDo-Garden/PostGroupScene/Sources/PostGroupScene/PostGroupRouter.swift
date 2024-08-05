//
//  PostGroupRouter.swift
//  
//
//  Created by SONG on 7/8/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import PostGroupSceneAPI

protocol PostGroupRoutingLogic {
  func routeToSomewhere()
}

protocol PostGroupDataPassing {
  var dataStore: PostGroupDataStore? { get set }
}

class PostGroupRouter: PostGroupDataPassing {
  weak var viewController: PostGroupViewController?
  var dataStore: PostGroupDataStore?
  private let nextSceneBuilder: NextSceneBuildable?
  
  init(nextSceneBuilder: NextSceneBuildable?) {
    self.nextSceneBuilder = nextSceneBuilder
  }
}

// MARK: - Routing

extension PostGroupRouter: PostGroupRoutingLogic {
  func routeToSomewhere() {
    guard let destinationViewController = self.nextSceneBuilder?.build(
      with: NextScenePayload()
    ) else { return }
    
    self.viewController?.present(destinationViewController, animated: true)
  }
}

// MARK: - Declare Payload for scene

extension PostGroupRouter {
  struct NextScenePayload: NextScenePayloadable {
    // var name: String
  }
}
