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
  func cancelEntireTask()
}

final class ShareGardenSceneInteractor: ShareGardenSceneDataStore {
  var presenter: ShareGardenScenePresentationLogic?
  private let shareGardenSceneWorker: ShareGardenSceneWorkable
  private let friendsGardenStore: FriendsGardenDataStore

  private var tasks: [TaskKey: Task<Void, Never>] = [:]

  enum TaskKey {
    case observeFriendsGardenStoreStream
  }

  init(shareGardenSceneWorker: ShareGardenSceneWorkable) {
    self.shareGardenSceneWorker = shareGardenSceneWorker
    self.friendsGardenStore = FriendsGardenDataStore()
    self.observeFriendsGardenStoreStream()
  }
}

// MARK: - Request to worker

extension ShareGardenSceneInteractor: ShareGardenSceneBusinessLogic {

  func cancelEntireTask() {
    self.tasks.keys.forEach { self.cancel(to: $0) }
  }
}

extension ShareGardenSceneInteractor: FriendsGardenStore {
  func fetch(by id: ShareGardenSceneEntity.ShareGardenScene.FriendsGarden.ID) -> ShareGardenScene.FriendsGarden? {

extension ShareGardenSceneInteractor {
  private func observeFriendsGardenStoreStream() {
    self.tasks[TaskKey.observeFriendsGardenStoreStream] = Task { [weak self] in
      guard let stream = await self?.friendsGardenStore.stream
      else { return }
      defer { self?.tasks[TaskKey.observeFriendsGardenStoreStream] = nil }

      for await friendsGardens in stream {
        // stream에서 받은 값을 기반으로 뷰 업데이트
        // let response = ShareGardenScene.RequestFriendsGardenList.Response(friendsGardenList: friendsGardens)
        // await self?.presenter?.presentFriendsGardens(response: response)
      }
    }
  }

  private func cancel(to key: TaskKey) {
    self.tasks[key]?.cancel()
    self.tasks[key] = nil
  }
}
