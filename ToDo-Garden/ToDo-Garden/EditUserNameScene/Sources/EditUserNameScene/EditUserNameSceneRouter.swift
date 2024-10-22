//
//  EditUserNameSceneRouter.swift
//  
//
//  Created by Wood on 9/23/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import EditUserNameSceneAPI

protocol EditUserNameSceneRoutingLogic {
  func routeToUserInfoScene()
}

protocol EditUserNameSceneDataPassing {
  var dataStore: EditUserNameSceneDataStore? { get set }
  var delegate: EditUserNameSceneDelegate? { get set }
}

class EditUserNameSceneRouter: EditUserNameSceneDataPassing {
  weak var viewController: EditUserNameSceneViewController?
  weak var delegate: EditUserNameSceneDelegate?
  var dataStore: EditUserNameSceneDataStore?
}

// MARK: - Routing

extension EditUserNameSceneRouter: EditUserNameSceneRoutingLogic {
  func routeToUserInfoScene() {
    self.viewController?.navigationController?.popViewController(animated: true)
  }
}

// MARK: - Declare Payload for scene

extension EditUserNameSceneRouter {
  struct NextScenePayload: NextScenePayloadable {
    // var name: String
  }
}
