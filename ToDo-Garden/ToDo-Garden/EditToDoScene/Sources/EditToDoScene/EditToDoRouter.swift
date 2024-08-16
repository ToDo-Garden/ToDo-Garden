//
//  EditToDoRouter.swift
//  
//
//  Created by Wood on 6/29/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import EditToDoSceneAPI

protocol EditToDoRoutingLogic {
  func routeToToDoListScene()
}

protocol EditToDoDataPassing {
  var dataStore: EditToDoDataStore? { get set }
}

class EditToDoRouter: EditToDoDataPassing {
  weak var viewController: EditToDoViewController?
  var dataStore: EditToDoDataStore?
}

// MARK: - Routing

extension EditToDoRouter: EditToDoRoutingLogic {
  func routeToToDoListScene() {
    self.viewController?.navigationController?.popViewController(animated: true)
  }
}
