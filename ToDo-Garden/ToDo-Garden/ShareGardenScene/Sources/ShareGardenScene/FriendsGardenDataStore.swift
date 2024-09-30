//
//  FriendsGardenDataStore.swift
//  ShareGardenScene
//
//  Created by Noah on 9/30/24.
//

import Foundation

import ShareGardenSceneEntity

@MainActor
final class FriendsGardenDataStore {
  private var friendsGardens: [ShareGardenScene.FriendsGarden] {
    didSet {
      self.continuation?.yield(self.friendsGardens)
    }
  }

  private var continuation: AsyncStream<[ShareGardenScene.FriendsGarden]>.Continuation?
  lazy var stream: AsyncStream<[ShareGardenScene.FriendsGarden]> = {
    return AsyncStream(
      bufferingPolicy: AsyncStream.Continuation.BufferingPolicy.bufferingNewest(1)
    ) { continuation in
      self.continuation = continuation
    }
  }()

  nonisolated init() {
    self.friendsGardens = []
  }

  deinit {
    self.continuation?.finish()
  }
}
