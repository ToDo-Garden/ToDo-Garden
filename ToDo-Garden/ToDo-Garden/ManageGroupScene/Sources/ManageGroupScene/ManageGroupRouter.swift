//
//  ManageGroupRouter.swift
//  
//
//  Created by SONG on 6/26/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import ManageGroupSceneAPI
import PostGroupSceneAPI

protocol ManageGroupRoutingLogic {
  func routeToSomewhere()
}

protocol ManageGroupDataPassing {
  var dataStore: ManageGroupDataStore? { get }
}

class ManageGroupRouter: ManageGroupDataPassing {
  weak var viewController: ManageGroupViewController?
  var dataStore: ManageGroupDataStore?
  private let nextSceneBuilder: NextSceneBuildable?
  
  init(nextSceneBuilder: NextSceneBuildable?) {
    self.nextSceneBuilder = nextSceneBuilder
  }
}

// MARK: - Routing

extension ManageGroupRouter: ManageGroupRoutingLogic {
  func routeToSomewhere() {
    guard let destinationViewController = self.nextSceneBuilder?.build(with: NextScenePayload()) else { return }
    
    self.viewController?.present(destinationViewController, animated: true)
  }
}

// MARK: - Declare Payload for scene

extension ManageGroupRouter {
  struct PostGroupScenePayload: PostGroupScenePayloadable {
    var groupID: String?
    var groupName: String?
    var groupColor: UIColor?
  }
}
