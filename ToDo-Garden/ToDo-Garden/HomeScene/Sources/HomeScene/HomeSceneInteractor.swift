//
//  HomeSceneInteractor.swift
//  HomeScene
//
//  Created by Noah on 1/9/25.
//  Copyright (c) 2025 ToDoGarden. All rights reserved.

import Foundation

protocol HomeSceneDataStore {
}

protocol HomeSceneBusinessLogic {
}

final class HomeSceneInteractor: HomeSceneDataStore {
  var presenter: (any HomeScenePresentationLogic)?
  
  init() {
  }
}

// MARK: - Request to worker

extension HomeSceneInteractor: HomeSceneBusinessLogic {
}
