//
//  ShareGardenSceneWorker.swift
//  
//
//  Created by Noah on 7/4/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import ShareGardenSceneAPI
import ShareGardenSceneEntity

// TODO: - ShareGardenSceneWorker 빈 구현 대체
struct ShareGardenSceneWorker: ShareGardenSceneWorkable {
  func requestFriendsGardenList() async throws -> [ShareGardenScene.FriendsGarden] {
    return []
  }
  
  func delete(by id: ShareGardenScene.FriendsGarden.ID) async throws {
    return
  }
}
