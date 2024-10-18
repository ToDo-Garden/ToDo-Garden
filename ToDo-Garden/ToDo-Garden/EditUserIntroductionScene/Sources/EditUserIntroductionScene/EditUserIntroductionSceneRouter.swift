//
//  EditUserIntroductionSceneRouter.swift
//  
//
//  Created by Wood on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import EditUserIntroductionSceneAPI
import EditUserIntroductionSceneEntity

protocol EditUserIntroductionSceneRoutingLogic {
  func routeToUserInfoScene()
}

protocol EditUserIntroductionSceneDataPassing {
  var dataStore: EditUserIntroductionSceneDataStore? { get set }
  var delegate: EditUserIntroductionDelegate? { get set }
}

class EditUserIntroductionSceneRouter: EditUserIntroductionSceneDataPassing {
  weak var viewController: EditUserIntroductionSceneViewController?
  weak var delegate: EditUserIntroductionDelegate?
  var dataStore: EditUserIntroductionSceneDataStore?
}

// MARK: - Routing

extension EditUserIntroductionSceneRouter: EditUserIntroductionSceneRoutingLogic {
  func routeToUserInfoScene() {
    self.viewController?.navigationController?.popViewController(animated: true)
  }
}

// MARK: - Declare Payload for scene

extension EditUserIntroductionSceneRouter {
  struct NextScenePayload: NextScenePayloadable {
    // var name: String
  }
}
