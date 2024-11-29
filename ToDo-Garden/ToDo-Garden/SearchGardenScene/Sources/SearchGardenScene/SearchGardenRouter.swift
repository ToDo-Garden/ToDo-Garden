//
//  SearchGardenRouter.swift
//
//
//  Created by SONG on 11/18/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SearchGardenSceneAPI
import SearchGardenSceneEntity

protocol SearchGardenRoutingLogic {
  func dismissModal()
}

protocol SearchGardenDataPassing {
  var dataStore: SearchGardenDataStore? { get }
}

class SearchGardenRouter: SearchGardenDataPassing {
  weak var viewController: SearchGardenViewController?
  var dataStore: SearchGardenDataStore?
  
  init() {
  }
}

// MARK: - Routing

extension SearchGardenRouter: SearchGardenRoutingLogic {
  func dismissModal() {
    self.viewController?.dismiss(animated: true)
  }
}
