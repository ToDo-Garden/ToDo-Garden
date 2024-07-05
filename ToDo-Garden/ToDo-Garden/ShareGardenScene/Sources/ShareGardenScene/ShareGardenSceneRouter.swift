//
//  ShareGardenSceneRouter.swift
//  
//
//  Created by Noah on 7/4/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import ShareGardenSceneAPI

protocol ShareGardenSceneRoutingLogic {
}

protocol ShareGardenSceneDataPassing {
  var dataStore: ShareGardenSceneDataStore? { get }
}

class ShareGardenSceneRouter: ShareGardenSceneDataPassing {
  weak var viewController: ShareGardenSceneViewController?
  var dataStore: ShareGardenSceneDataStore?
  
  init() {
  }
}

// MARK: - Routing

extension ShareGardenSceneRouter: ShareGardenSceneRoutingLogic {
}
