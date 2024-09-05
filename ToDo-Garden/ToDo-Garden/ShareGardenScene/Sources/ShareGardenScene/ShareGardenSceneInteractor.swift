//
//  ShareGardenSceneInteractor.swift
//  
//
//  Created by Noah on 7/4/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import ShareGardenSceneAPI
import ShareGardenSceneEntity

protocol ShareGardenSceneDataStore {
}

protocol ShareGardenSceneBusinessLogic {
}

final class ShareGardenSceneInteractor: ShareGardenSceneDataStore {
  var presenter: ShareGardenScenePresentationLogic?
  private let shareGardenSceneWorker: ShareGardenSceneWorkable
  
  init(shareGardenSceneWorker: ShareGardenSceneWorkable) {
    self.shareGardenSceneWorker = shareGardenSceneWorker
  }
}

// MARK: - Request to worker

extension ShareGardenSceneInteractor: ShareGardenSceneBusinessLogic {
}

extension ShareGardenSceneInteractor: FriendsGardenStore {
  func fetchBy(_ id: ShareGardenSceneEntity.ShareGardenScene.FriendsGarden.ID) -> ShareGardenScene.FriendsGarden? {
    return nil
  }
}
