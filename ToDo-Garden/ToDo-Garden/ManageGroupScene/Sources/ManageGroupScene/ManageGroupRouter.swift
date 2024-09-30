//
//  ManageGroupRouter.swift
//  
//
//  Created by SONG on 6/26/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit.UIColor

import ManageGroupSceneAPI
import ManageGroupSceneEntity
import PostGroupSceneAPI
import PostGroupSceneEntity

protocol ManageGroupRoutingLogic {
  func routeToPostGroupScene(groupInfo: ManageGroup.ToDoGroup?)
}

protocol ManageGroupDataPassing {
  var dataStore: ManageGroupDataStore? { get }
}

class ManageGroupRouter: ManageGroupDataPassing {
  weak var viewController: ManageGroupViewController?
  var dataStore: ManageGroupDataStore?
  private let postSceneBuilder: PostGroupSceneBuildable?
  
  init(postSceneBuilder: PostGroupSceneBuildable?) {
    self.postSceneBuilder = postSceneBuilder
  
  }
}

// MARK: - Routing

extension ManageGroupRouter: ManageGroupRoutingLogic {
  func routeToPostGroupScene(groupInfo: ManageGroup.ToDoGroup?) {
    var payload: PostGroupScenePayload?
    if let groupInfo {
      payload = PostGroupScenePayload(
        group: PostGroup.ToDoGroup(
          groupID: groupInfo.groupID,
          groupName: groupInfo.groupName,
          groupColor: groupInfo.progressColor
        )
      )
    } else {
      payload = nil
    }

    guard let destinationViewController = self.postSceneBuilder?.build(
      with: payload,
      delegate: self.viewController
    ) else {
      return
    }
    
    self.viewController?.navigationController?.pushViewController(destinationViewController, animated: true)
  }
}

// MARK: - Declare Payload for scene

extension ManageGroupRouter {
  struct PostGroupScenePayload: PostGroupScenePayloadable {
    var group: PostGroup.ToDoGroup
  }
}
