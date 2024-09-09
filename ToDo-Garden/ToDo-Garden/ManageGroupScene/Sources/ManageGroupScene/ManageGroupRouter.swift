//
//  ManageGroupRouter.swift
//  
//
//  Created by SONG on 6/26/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit.UIColor

import ManageGroupSceneAPI
import PostGroupSceneAPI

protocol ManageGroupRoutingLogic {
  func routeToPostGroupScene(
    groupId: String?,
    groupName: String?,
    groupColor: UIColor?
  )
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
  func routeToPostGroupScene(
    groupId: String?,
    groupName: String?,
    groupColor: UIColor?
  ) {
    let payload = PostGroupScenePayload(
      groupID: groupId,
      groupName: groupName,
      groupColor: groupColor
    )
    guard let destinationViewController = self.postSceneBuilder?.build(with: payload) else {
      return
    }
    
    self.viewController?.navigationController?.pushViewController(destinationViewController, animated: true)
  }
}

// MARK: - Declare Payload for scene

extension ManageGroupRouter {
  struct PostGroupScenePayload: PostGroupScenePayloadable {
    var groupID: String?
    var groupName: String?
    var groupColor: UIColor?
  }
}
