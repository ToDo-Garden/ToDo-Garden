//
//  EditToDoRouter.swift
//  
//
//  Created by Wood on 6/29/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import EditToDoSceneAPI

@MainActor
protocol EditToDoRoutingLogic {
  func routeToHomeScene()
  func routeToHomeSceneWithToDo(isNeededDeletionBySelection: Bool)
  func routeToHomeSceneWithDeletedToDo()
}

@MainActor
protocol EditToDoDataPassing {
  var dataStore: EditToDoDataStore? { get set }
  var delegate: EditToDoSceneDelegate? { get set }
}

@MainActor
class EditToDoRouter: EditToDoDataPassing {
  weak var viewController: EditToDoViewController?
  weak var delegate: EditToDoSceneDelegate?
  var dataStore: EditToDoDataStore?
}

// MARK: - Routing

// swiftlint:disable all
extension EditToDoRouter: EditToDoRoutingLogic {
  func routeToHomeScene() {
    self.viewController?.navigationController?.popViewController(animated: true)
  }

  func routeToHomeSceneWithToDo(isNeededDeletionBySelection: Bool) {
    self.delegate?.didEdit(
      toDo: self.dataStore!.toDo!,
      isNeededDeletionBySelection: isNeededDeletionBySelection
    )
    self.routeToHomeScene()
  }

  func routeToHomeSceneWithDeletedToDo() {
    self.delegate?.didRemove(toDo: self.dataStore!.toDo!)
    self.routeToHomeScene()
  }
}
// swiftlint:enable all
