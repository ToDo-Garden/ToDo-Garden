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
  func loadFriendGarden(request: SearchGarden.LoadFriendGarden.Request)
  func addGarden()
  func cancelTask(for key: SearchGardenInteractor.TaskKey)
  func loadSearchedGarden(request: SearchGarden.LoadSearchedGarden.Request)
  func loadSearchedGardenContinue(request: SearchGarden.LoadSearchedGarden.Request)
}

final class SearchGardenInteractor: SearchGardenDataStore {
  var presenter: SearchGardenPresentationLogic?
  private let searchGardenWorker: SearchGardenWorkable
  private var tasks: [TaskKey: Task<Void, Never>] = [:]
  private var currentSelectedUser: SearchGarden.CurrentSelectedUser?
  private var currentState = CurrentState()
  
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
  func loadFriendGarden(request: SearchGarden.LoadFriendGarden.Request) {
    self.tasks[TaskKey.loadUserDataForAddingGarden] = Task {
      defer { self.tasks[TaskKey.loadUserDataForAddingGarden] = nil }
      do {
        try Task.checkCancellation()
        self.currentSelectedUser = SearchGarden.CurrentSelectedUser(userID: request.userID)
        let fetchedData = try await self.searchGardenWorker.loadFriendGarden(userID: request.userID)
        try Task.checkCancellation()
        let response = SearchGarden.LoadFriendGarden.Response(
          userID: request.userID,
          userImage: request.userImage,
          fetchedData: fetchedData
        )
        self.presenter?.presentUserDataForAddingGarden(response: response)
      } catch let error {
        self.handleError(error: error, task: TaskKey.loadUserDataForAddingGarden)
      }
    }
  }
  
  func addGarden() {
    guard let currentSelectedUser else { return }
    
    self.tasks[TaskKey.addGarden] = Task {
      defer { self.tasks[TaskKey.addGarden] = nil }
      do {
        try Task.checkCancellation()
        try await self.searchGardenWorker.addGarden(userID: currentSelectedUser.userID)
        try Task.checkCancellation()
        self.presenter?.presentResultOfAddingGarden()
      } catch let error {
        self.handleError(error: error, task: TaskKey.addGarden)
      }
    }
  }
  
  func loadSearchedGarden(request: SearchGarden.LoadSearchedGarden.Request) {
    self.currentState.isEndPage = false
    self.currentState.page = Int.zero
    self.tasks[TaskKey.loadSearchedGarden] = Task {
      defer { self.tasks[TaskKey.loadSearchedGarden] = nil }
      do {
        try Task.checkCancellation()
        let fetchedData = try await self.searchGardenWorker.loadSearchedGardenList(
          inputText: request.inputText,
          page: self.currentState.page
        )
        self.currentState.isEndPage = fetchedData.isEndPage
        try Task.checkCancellation()
        let response = SearchGarden.LoadSearchedGarden.Response(fetchedData: fetchedData)
        self.presenter?.presentGardenForSearchingGarden(response: response)
      } catch is CancellationError {
        return // TODO: presenter에 error시 호출될 메서드 구현 예정
      } catch let error {
        self.handleError(error: error, task: TaskKey.loadSearchedGarden)
      }
    }
  }
  
  func loadSearchedGardenContinue(request: SearchGarden.LoadSearchedGarden.Request) {
    guard !self.currentState.isEndPage else { return }
    
    self.currentState.page += 1
    self.loadSearchedGarden(
      request: SearchGarden.LoadSearchedGarden.Request(inputText: self.currentState.inputText)
    )
  }
  
  @MainActor
  private func handleError(error: Error, task: TaskKey) {
    debugPrint(error)
    self.presenter?.presentErrorInfoToast(error: error)
  }
}

extension SearchGardenInteractor {
  enum TaskKey {
    case loadUserDataForAddingGarden
    case addGarden
    case loadSearchedGarden
  }
  
  struct CurrentState: Sendable {
    var page: Int = 0
    var isEndPage: Bool = true
    var inputText: String = ""
  }
}
