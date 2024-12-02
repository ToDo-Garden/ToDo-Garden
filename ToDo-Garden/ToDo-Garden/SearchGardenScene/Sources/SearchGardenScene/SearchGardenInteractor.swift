//
//  SearchGardenInteractor.swift
//
//
//  Created by SONG on 11/18/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SearchGardenSceneAPI
import SearchGardenSceneEntity

protocol SearchGardenDataStore {
  // var name: String { get set }
}

protocol SearchGardenBusinessLogic {
  func loadUserDataForAddingGarden(request: SearchGarden.LoadUserDataForAddingGarden.Request)
}

class SearchGardenInteractor: SearchGardenDataStore {
  var presenter: SearchGardenPresentationLogic?
  private let searchGardenWorker: SearchGardenWorkable
  private var currentSelectedUser: SearchGarden.CurrentSelectedUser?
  // ↑ 가든 추가 흐름에서 쓰일 예정
  
  init(searchGardenWorker: SearchGardenWorkable) {
    self.searchGardenWorker = searchGardenWorker
  }
}

// MARK: - Request to worker

extension SearchGardenInteractor: SearchGardenBusinessLogic {
  func loadUserDataForAddingGarden(request: SearchGarden.LoadUserDataForAddingGarden.Request) {
    Task {
      self.currentSelectedUser = SearchGarden.CurrentSelectedUser(userID: request.userID)
      let fetchedData = await self.searchGardenWorker.fetchUserDataForAddingGarden(userID: request.userID)
      let response = SearchGarden.LoadUserDataForAddingGarden.Response(
        userID: request.userID,
        userImage: request.userImage,
        fetchedData: fetchedData
      )
      self.presenter?.presentUserDataForAddingGarden(response: response)
    }
  }
}
