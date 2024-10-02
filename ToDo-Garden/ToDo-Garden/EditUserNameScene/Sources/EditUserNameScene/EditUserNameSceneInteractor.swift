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
  var userName: String? { get }
}

protocol EditUserNameSceneBusinessLogic {
  func setUserName()
  func verifyUserName(_ userName: String)
}

final class EditUserNameSceneInteractor: EditUserNameSceneDataStore {
  var userName: String?

  var presenter: EditUserNameScenePresentationLogic?
  private let editUserNameWorker: EditUserNameSceneWorkable

  init(editUserNameWorker: EditUserNameSceneWorkable) {
    self.editUserNameWorker = editUserNameWorker
  }
}

// MARK: - Request to worker

extension EditUserNameSceneInteractor: EditUserNameSceneBusinessLogic {
  func setUserName() {
    self.presenter?.presentUserName(self.userName)
  }

  func verifyUserName(_ userName: String) {
    print(userName)
  }
}
