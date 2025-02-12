//
//  PostGroupRouter.swift
//  
//
//  Created by SONG on 7/8/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import PostGroupSceneAPI
import PostGroupSceneEntity

protocol PostGroupDataPassing {
  var dataStore: PostGroupDataStore? { get set }
  
  func routeToManageGroupScene()
}

class PostGroupRouter: PostGroupDataPassing {
  weak var viewController: PostGroupViewController?
  var dataStore: PostGroupDataStore?
  
  init() {
  }

  func routeToManageGroupScene() {
    self.viewController?.navigationController?.popViewController(animated: true)
  }
}
