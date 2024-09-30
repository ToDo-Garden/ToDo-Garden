//
//  FriendsGardenStore.swift
//  ShareGardenScene
//
//  Created by Noah on 9/30/24.
//

import Foundation

import ShareGardenSceneEntity

protocol FriendsGardenStore: AnyObject {
  func fetchBy(_ id: ShareGardenScene.FriendsGarden.ID) -> ShareGardenScene.FriendsGarden?
}
