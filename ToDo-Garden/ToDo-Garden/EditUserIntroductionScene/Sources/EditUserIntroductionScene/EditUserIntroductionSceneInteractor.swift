//
//  EditUserIntroductionSceneInteractor.swift
//
//
//  Created by Wood on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import EditUserIntroductionSceneAPI
import EditUserIntroductionSceneEntity

protocol EditUserIntroductionSceneDataStore {
  // var name: String { get set }
}

protocol EditUserIntroductionSceneBusinessLogic {
}

class EditUserIntroductionSceneInteractor: EditUserIntroductionSceneDataStore {
  // var name: String = ""
  var presenter: EditUserIntroductionScenePresentationLogic?
  private let someWorker: EditUserIntroductionSceneWorkable

  init(someWorker: EditUserIntroductionSceneWorkable) {
    self.someWorker = someWorker
  }
}

// MARK: - Request to worker

extension EditUserIntroductionSceneInteractor: EditUserIntroductionSceneBusinessLogic {
}
