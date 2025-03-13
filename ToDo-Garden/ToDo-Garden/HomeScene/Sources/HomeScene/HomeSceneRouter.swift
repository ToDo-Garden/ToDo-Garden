//
//  HomeSceneRouter.swift
//  HomeScene
//
//  Created by Noah on 1/9/25.
//  Copyright (c) 2025 ToDoGarden. All rights reserved.

import Foundation

import EditToDoSceneAPI
import ManageGroupSceneAPI
import TimerSceneAPI

protocol HomeSceneRoutingLogic {
  @MainActor func routeToManageGroupScene()
  @MainActor func routeToEditToDoScene(toDoId: UUID)
  @MainActor func routeToTimerScene(groupId: String, groupName: String)
}

protocol HomeSceneDataPassing {
  var dataStore: HomeSceneDataStore? { get }
}

final class HomeSceneRouter: HomeSceneDataPassing {
  weak var viewController: HomeSceneViewController?
  var dataStore: (any HomeSceneDataStore)?
  private let manageGroupSceneBuilder: ManageGroupSceneBuildable
  private let editToDoSceneBuilder: EditToDoSceneBuildable
  private let timerSceneBuilder: TimerSceneBuildable
  
  init(
    manageGroupSceneBuilder: ManageGroupSceneBuildable,
    editToDoSceneBuilder: EditToDoSceneBuildable,
    timerSceneBuilder: TimerSceneBuildable
  ) {
    self.manageGroupSceneBuilder = manageGroupSceneBuilder
    self.editToDoSceneBuilder = editToDoSceneBuilder
    self.timerSceneBuilder = timerSceneBuilder
  }
}

// MARK: - Routing

extension HomeSceneRouter: HomeSceneRoutingLogic {
  func routeToManageGroupScene() {
    let destinationViewController = self.manageGroupSceneBuilder.build()
    
    self.viewController?.navigationController?.pushViewController(destinationViewController, animated: true)
  }
  
  func routeToEditToDoScene(toDoId: UUID) {
    let payload = EditToDoScenePayload(toDoId: toDoId)
    let destinationViewController = self.editToDoSceneBuilder.build(with: payload)
    
    self.viewController?.navigationController?.pushViewController(destinationViewController, animated: true)
  }
  
  func routeToTimerScene(groupId: String, groupName: String) {
    let payload = TimerScenePayload(groupId: groupId, groupName: groupName)
    let destinationViewController = self.timerSceneBuilder.build(with: payload)
    
    self.viewController?.navigationController?.pushViewController(destinationViewController, animated: true)
  }
}

// MARK: - Declare Payload for scene
struct EditToDoScenePayload: EditToDoScenePayloadable {
  var toDoId: UUID
  
  init(toDoId: UUID) {
    self.toDoId = toDoId
  }
}

struct TimerScenePayload: TimerScenePayloadable {
  var groupId: String
  var groupName: String
  
  init(groupId: String, groupName: String) {
    self.groupId = groupId
    self.groupName = groupName
  }
}
