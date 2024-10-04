//
//  ShareGardenSceneWorkable.swift
//  
//
//  Created by Noah on 7/4/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import ShareGardenSceneEntity

public protocol ShareGardenSceneWorkable: Sendable {
  func requestFriendsGardenList() async throws -> [ShareGardenScene.FriendsGarden]
  func delete(by id: ShareGardenScene.FriendsGarden.ID) async throws
  func requestMyGarden() async throws -> ShareGardenScene.MyGarden
}
