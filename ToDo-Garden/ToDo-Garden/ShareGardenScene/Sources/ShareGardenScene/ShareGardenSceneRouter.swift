//
//  ShareGardenSceneRouter.swift
//  
//
//  Created by Noah on 7/4/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import TDFoundation

import ShareGardenSceneAPI

@MainActor
protocol ShareGardenSceneRoutingLogic {
  func routeToInstaShareClient(icon: UIImage)
}

@MainActor
protocol ShareGardenSceneDataPassing {
  var dataStore: ShareGardenSceneDataStore? { get }
}

final class ShareGardenSceneRouter: ShareGardenSceneDataPassing {
  weak var viewController: ShareGardenSceneViewController?
  var dataStore: ShareGardenSceneDataStore?
  
  init() {
  }
}

// MARK: - Routing

extension ShareGardenSceneRouter: ShareGardenSceneRoutingLogic {
  func routeToInstaShareClient(icon: UIImage) {
  }
}
