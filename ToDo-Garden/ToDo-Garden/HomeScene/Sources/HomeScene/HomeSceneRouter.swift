//
//  HomeSceneRouter.swift
//  HomeScene
//
//  Created by Noah on 1/9/25.
//  Copyright (c) 2025 ToDoGarden. All rights reserved.

import Foundation

protocol HomeSceneRoutingLogic {
}

protocol HomeSceneDataPassing {
  var dataStore: HomeSceneDataStore? { get }
}

final class HomeSceneRouter: HomeSceneDataPassing {
  weak var viewController: HomeSceneViewController?
  var dataStore: (any HomeSceneDataStore)?
  
  init() {
  }
}

// MARK: - Routing

extension HomeSceneRouter: HomeSceneRoutingLogic {
}

// MARK: - Declare Payload for scene
