//
//  MyStatsRouter.swift
//  
//
//  Created by SONG on 11/13/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import MyStatsSceneAPI

protocol MyStatsRoutingLogic {
  func routeToSomewhere()
}

protocol MyStatsDataPassing {
  var dataStore: MyStatsDataStore? { get }
}

class MyStatsRouter: MyStatsDataPassing {
  weak var viewController: MyStatsViewController?
  var dataStore: MyStatsDataStore?
  
  init() {}
}

// MARK: - Routing

extension MyStatsRouter: MyStatsRoutingLogic {
  func routeToSomewhere() {
  }
}
