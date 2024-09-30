//
//  FriendsGardenStore.swift
//  ShareGardenScene
//
//  Created by Noah on 9/30/24.
//

import Foundation

import ShareGardenSceneEntity

@MainActor
protocol FriendsGardenStore: AnyObject {
  func fetch(by id: ShareGardenScene.FriendsGarden.ID) -> ShareGardenScene.FriendsGarden?
}
