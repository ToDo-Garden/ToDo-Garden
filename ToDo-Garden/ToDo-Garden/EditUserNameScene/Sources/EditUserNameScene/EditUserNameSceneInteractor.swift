//
//  EditUserNameSceneInteractor.swift
//  
//
//  Created by Wood on 9/23/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import EditUserNameSceneAPI
import EditUserNameSceneEntity

protocol EditUserNameSceneDataStore {
  // var name: String { get set }
}

protocol EditUserNameSceneBusinessLogic {
}

class EditUserNameSceneInteractor: EditUserNameSceneDataStore {
  // var name: String = ""
  var presenter: EditUserNameScenePresentationLogic?
  private let editUserNameWorker: EditUserNameSceneWorkable

  init(editUserNameWorker: EditUserNameSceneWorkable) {
    self.editUserNameWorker = editUserNameWorker
  }
}

// MARK: - Request to worker

extension EditUserNameSceneInteractor: EditUserNameSceneBusinessLogic {}
