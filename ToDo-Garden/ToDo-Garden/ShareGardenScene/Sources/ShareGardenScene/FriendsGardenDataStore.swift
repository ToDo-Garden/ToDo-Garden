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
      self.continuation.yield(self.friendsGardens)
    }
  }
  
  let (stream, continuation) = AsyncStream.makeStream(
    of: [ShareGardenScene.FriendsGarden].self,
    bufferingPolicy: AsyncStream.Continuation.BufferingPolicy.bufferingNewest(1)
  )

  nonisolated init() {
    self.friendsGardens = []
  }

  deinit {
    self.continuation.finish()
  }

  func append(_ newFriendsGarden: ShareGardenScene.FriendsGarden) {
    self.friendsGardens.append(newFriendsGarden)
  }

  func fetch(by id: ShareGardenScene.FriendsGarden.ID) -> ShareGardenScene.FriendsGarden? {
    return self.friendsGardens.first { $0.id == id }
  }

  func fetchAll() -> [ShareGardenScene.FriendsGarden] {
    return self.friendsGardens
  }

  func update(to friendsGardens: [ShareGardenScene.FriendsGarden]) {
    self.friendsGardens = friendsGardens
  }

  func delete(by id: ShareGardenScene.FriendsGarden.ID) {
    if let index = self.friendsGardens.firstIndex(where: { $0.id == id }) {
      self.friendsGardens.remove(at: index)
    }
  }
}
