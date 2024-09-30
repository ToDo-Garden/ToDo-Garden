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
  func requestFriendsGardenList()
  func cancelEntireTask()
}

final class ShareGardenSceneInteractor: ShareGardenSceneDataStore {
  var presenter: ShareGardenScenePresentationLogic?
  private let shareGardenSceneWorker: ShareGardenSceneWorkable
  private let friendsGardenStore: FriendsGardenDataStore

  private var tasks: [TaskKey: Task<Void, Never>] = [:]

  enum TaskKey {
    case requestFriendsGardenList
    case observeFriendsGardenStoreStream
    case deleteFriendsGarden
  }

  init(shareGardenSceneWorker: ShareGardenSceneWorkable) {
    self.shareGardenSceneWorker = shareGardenSceneWorker
    self.friendsGardenStore = FriendsGardenDataStore()
    self.observeFriendsGardenStoreStream()
  }
}

// MARK: - Conform ShareGardenSceneBusinessLogic protocol

extension ShareGardenSceneInteractor: ShareGardenSceneBusinessLogic {
  func requestFriendsGardenList() {
    self.tasks[TaskKey.requestFriendsGardenList ] = Task { [weak self] in
      guard let self else { return }
      defer { self.tasks[TaskKey.requestFriendsGardenList] = nil }
      do {
        // TODO: - worker에 FriendsGardenList 비동기 요청
        // let friendsGardenList = try await self.shareGardenSceneWorker.requestFriendsGardenList()
        if Task.isCancelled { return }
        // TODO: - friends Garden data store 업데이트
        // self.friendsGardenStore.update(to: friendsGardenList)
      } catch {
        // TODO: - error handling (error view 표시 예정)
      }
    }
  }

  func cancelEntireTask() {
    self.tasks.keys.forEach { self.cancel(to: $0) }
  }
}

extension ShareGardenSceneInteractor: FriendsGardenStore {
  func fetch(by id: ShareGardenSceneEntity.ShareGardenScene.FriendsGarden.ID) -> ShareGardenScene.FriendsGarden? {

  func delete(by id: ShareGardenScene.FriendsGarden.ID) {
    let rollback = self.friendsGardenStore.fetchAll()
    self.friendsGardenStore.delete(by: id)
    
    self.tasks[TaskKey.deleteFriendsGarden] = Task { [weak self] in
      guard let self else { return }
      defer { self.tasks[TaskKey.deleteFriendsGarden] = nil }

      do {
        // TODO: - worker에 삭제 요청
        // try await self.shareGardenSceneWorker.delete(by: id)
        if Task.isCancelled {
          self.friendsGardenStore.update(to: rollback)
          return
        }
      } catch {
        self.friendsGardenStore.update(to: rollback)
      }
    }
  }
}

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
