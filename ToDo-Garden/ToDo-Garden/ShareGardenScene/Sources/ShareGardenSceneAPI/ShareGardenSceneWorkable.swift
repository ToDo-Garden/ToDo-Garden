//
//  ShareGardenSceneWorkable.swift
//  
//
//  Created by Noah on 7/4/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import ShareGardenSceneEntity

public protocol ShareGardenSceneWorkable {
  func requestFriendsGardenList() async throws -> [ShareGardenScene.FriendsGarden]
}
