//
//  SearchGardenInteractor.swift
//
//
//  Created by SONG on 11/18/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import HTTPClientAPI
import SearchGardenSceneAPI
import SearchGardenSceneEntity

protocol SearchGardenDataStore {
  // var name: String { get set }
}

@MainActor
protocol SearchGardenBusinessLogic {
  func loadUserDataForAddingGarden(request: SearchGarden.LoadUserDataForAddingGarden.Request)
  func addGarden(request: SearchGarden.AddGarden.Request)
  func cancelTask(for key: SearchGarden.TaskKey)
}

final class SearchGardenInteractor: SearchGardenDataStore {
  var presenter: SearchGardenPresentationLogic?
  private let searchGardenWorker: SearchGardenWorkable
  private var tasks: [SearchGarden.TaskKey: Task<Void, Never>] = [:]
  private var currentSelectedUser: SearchGarden.CurrentSelectedUser?
  // ↑ 가든 추가 흐름에서 쓰일 예정
  
  init(searchGardenWorker: SearchGardenWorkable) {
    self.searchGardenWorker = searchGardenWorker
  }
  
  func cancelTask(for key: SearchGarden.TaskKey) {
    self.tasks[key]?.cancel()
    self.tasks[key] = nil
  }
}

// MARK: - Request to worker

extension SearchGardenInteractor: SearchGardenBusinessLogic {
  func loadUserDataForAddingGarden(request: SearchGarden.LoadUserDataForAddingGarden.Request) {
    self.tasks[SearchGarden.TaskKey.loadUserDataForAddingGarden] = Task {
      do {
        try Task.checkCancellation()
        self.currentSelectedUser = SearchGarden.CurrentSelectedUser(userID: request.userID)
        let fetchedData = try await self.searchGardenWorker.fetchUserDataForAddingGarden(userID: request.userID)
        let response = SearchGarden.LoadUserDataForAddingGarden.Response(
          userID: request.userID,
          userImage: request.userImage,
          fetchedData: fetchedData
        )
        self.presenter?.presentUserDataForAddingGarden(response: response)
      } catch is CancellationError {
        return
      } catch let error as HTTPClientError {
        switch error {
        default: return
        }
      } catch { return }
    }
  }
  
  func addGarden(request: SearchGarden.AddGarden.Request) {
    guard let currentSelectedUser else { return }
    
    self.tasks[SearchGarden.TaskKey.addGarden] = Task {
      do {
        try Task.checkCancellation()
        let result = try await self.searchGardenWorker.requestToAddGarden(userID: currentSelectedUser.userID)
        try Task.checkCancellation()
        let response = SearchGarden.AddGarden.Response(result: result)
        self.presenter?.presentResultOfAddingGarden(response: response)
      } catch is CancellationError {
        return
      } catch let error as HTTPClientError {
        switch error {
        default: return
        }
      } catch { return }
    }
  }
}
