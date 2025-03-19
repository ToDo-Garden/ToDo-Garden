//
//  HomeSceneInteractor.swift
//  HomeScene
//
//  Created by Noah on 1/9/25.
//  Copyright (c) 2025 ToDoGarden. All rights reserved.

import Foundation

import HomeSceneAPI

protocol HomeSceneDataStore {
}

@MainActor
protocol HomeSceneBusinessLogic {
  func fetchToDoList() async
  func createToDo() async
  func deleteToDo() async
}

@MainActor
final class HomeSceneInteractor: HomeSceneDataStore {
  var presenter: (any HomeScenePresentationLogic)?
  private var homeSceneWorker: HomeSceneWorkable
  
  init(homeSceneWorker: HomeSceneWorkable) {
    self.homeSceneWorker = homeSceneWorker
  }
}

// MARK: - Request to worker
extension HomeSceneInteractor: HomeSceneBusinessLogic {
  func fetchToDoList() async {
    do {
      let fetchedToDoList = try await self.homeSceneWorker.fetchToDoList()
      self.presenter?.presentFetchedToDoList(response: fetchedToDoList)
    } catch let error {
      self.handleErrors(error)
    }
  }
  
  func createToDo() async {
    do {
      try await self.homeSceneWorker.createToDo()
      self.presenter?.presentCreateToDo()
    } catch let error {
      self.handleErrors(error)
    }
  }
  
  func deleteToDo() async {
    do {
      try await self.homeSceneWorker.deleteToDo()
      self.presenter?.presentDeleteToDo()
    } catch let error {
      self.handleErrors(error)
    }
  }
}

// MARK: - HandleErrors

extension HomeSceneInteractor {
  private func handleErrors(_ error: Error) {
    switch error {
    default:
      break
    }
  }
}
