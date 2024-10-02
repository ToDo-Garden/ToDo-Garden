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

@MainActor
protocol ShareGardenSceneBusinessLogic {
  func requestFriendsGardenList()
  func cancelEntireTask()
}

@MainActor
final class ShareGardenSceneInteractor: ShareGardenSceneDataStore {
  var presenter: ShareGardenScenePresentationLogic?
  private let shareGardenSceneWorker: ShareGardenSceneWorkable
  private let friendsGardenDataStore: FriendsGardenDataStore
  
  private var tasks: [TaskKey: Task<Void, Never>] = [:]
  
  enum TaskKey {
    case requestFriendsGardenList
    case observeFriendsGardenStoreStream
    case deleteFriendsGarden
  }
  
  init(shareGardenSceneWorker: ShareGardenSceneWorkable) {
    self.shareGardenSceneWorker = shareGardenSceneWorker
    self.friendsGardenDataStore = FriendsGardenDataStore()
    self.observeFriendsGardenStoreStream()
  }
}

// MARK: - Conform ShareGardenSceneBusinessLogic protocol

extension ShareGardenSceneInteractor: ShareGardenSceneBusinessLogic {
  func requestFriendsGardenList() {
    self.tasks[TaskKey.requestFriendsGardenList] = Task {
      defer { self.tasks[TaskKey.requestFriendsGardenList] = nil }
      do {
        let friendsGardenList = try await self.shareGardenSceneWorker.requestFriendsGardenList()
        if Task.isCancelled { return }
        
        self.presenter?.stopShimmeringFriendsGardenList()
        self.friendsGardenDataStore.update(to: friendsGardenList)
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
    return self.friendsGardenDataStore.fetch(by: id)
  }
  
  func delete(by id: ShareGardenScene.FriendsGarden.ID) {
    let rollback = self.friendsGardenDataStore.fetchAll()
    self.friendsGardenDataStore.delete(by: id)
    
    self.tasks[TaskKey.deleteFriendsGarden] = Task(priority: TaskPriority.background) {
      defer { self.tasks[TaskKey.deleteFriendsGarden] = nil }
      
      do {
        try await self.shareGardenSceneWorker.delete(by: id)
        try Task.checkCancellation()
      } catch {
        self.friendsGardenDataStore.update(to: rollback)
      }
    }
  }
}

extension ShareGardenSceneInteractor {
  private func observeFriendsGardenStoreStream() {
    self.tasks[TaskKey.observeFriendsGardenStoreStream] = Task { [weak self] in
      guard let stream = self?.friendsGardenDataStore.stream
      else { return }
      defer { self?.tasks[TaskKey.observeFriendsGardenStoreStream] = nil }
      
      for await friendsGardens in stream {
        let response = ShareGardenScene.RequestFriendsGardenList.Response(friendsGardenList: friendsGardens)
        self?.presenter?.presentFriendsGardens(response: response)
      }
    }
  }
  
  private func cancel(to key: TaskKey) {
    self.tasks[key]?.cancel()
    self.tasks[key] = nil
  }
}
