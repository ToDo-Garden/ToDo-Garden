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
  func cancelTask(for key: SearchGardenInteractor.TaskKey)
  func loadSearchedGarden(request: SearchGarden.LoadSearchedGarden.Request)
}

final class SearchGardenInteractor: SearchGardenDataStore {
  var presenter: SearchGardenPresentationLogic?
  private let searchGardenWorker: SearchGardenWorkable
  private var tasks: [TaskKey: Task<Void, Never>] = [:]
  private var currentSelectedUser: SearchGarden.CurrentSelectedUser?
  private var recentPage: Int = 0
  
  init(searchGardenWorker: SearchGardenWorkable) {
    self.searchGardenWorker = searchGardenWorker
  }
  
  func cancelTask(for key: TaskKey) {
    self.tasks[key]?.cancel()
    self.tasks[key] = nil
  }
}

// MARK: - Request to worker

extension SearchGardenInteractor: SearchGardenBusinessLogic {
  func loadUserDataForAddingGarden(request: SearchGarden.LoadUserDataForAddingGarden.Request) {
    self.tasks[TaskKey.loadUserDataForAddingGarden] = Task {
      defer { self.tasks[TaskKey.loadUserDataForAddingGarden] = nil }
      do {
        try Task.checkCancellation()
        self.currentSelectedUser = SearchGarden.CurrentSelectedUser(userID: request.userID)
        let fetchedData = try await self.searchGardenWorker.fetchUserDataForAddingGarden(userID: request.userID)
        try Task.checkCancellation()
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
    
    self.tasks[TaskKey.addGarden] = Task {
      defer { self.tasks[TaskKey.addGarden] = nil }
      do {
        try Task.checkCancellation()
        let result = try await self.searchGardenWorker.requestToAddGarden(userID: currentSelectedUser.userID)
        try Task.checkCancellation()
        let response = SearchGarden.AddGarden.Response(result: result)
        self.presenter?.presentResultOfAddingGarden(response: response)
      } catch is CancellationError {
        return // TODO: presenter에 error시 호출될 메서드 구현 예정 
      } catch let error as HTTPClientError {
        switch error {
        default: return // TODO: presenter에 error시 호출될 메서드 구현 예정
        }
      } catch { return } // TODO: presenter에 error시 호출될 메서드 구현 예정
    }
  }
  
  func loadSearchedGarden(request: SearchGarden.LoadSearchedGarden.Request) {
    self.tasks[TaskKey.loadSearchedGarden] = Task {
      defer { self.tasks[TaskKey.loadSearchedGarden] = nil }
      do {
        try Task.checkCancellation()
        if request.isContinuous {
          self.recentPage += 1
        } else {
          self.recentPage = Int.zero
        }
        let fetchedData = try await self.searchGardenWorker.fetchSearchedGardenData(
          inputText: request.inputText,
          page: self.recentPage
        )
        try Task.checkCancellation()
        let response = SearchGarden.LoadSearchedGarden.Response(fetchedData: fetchedData)
        self.presenter?.presentGardenForSearchingGarden(response: response)
      } catch is CancellationError {
        return // TODO: presenter에 error시 호출될 메서드 구현 예정
      } catch let error as HTTPClientError {
        switch error {
        default: return // TODO: presenter에 error시 호출될 메서드 구현 예정
        }
      } catch { return }
    }
  }
}

extension SearchGardenInteractor {
  enum TaskKey {
    case loadUserDataForAddingGarden
    case addGarden
    case loadSearchedGarden
  }
}
