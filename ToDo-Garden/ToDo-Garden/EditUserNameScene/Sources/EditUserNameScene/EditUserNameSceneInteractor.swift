//
//  EditUserNameSceneInteractor.swift
//
//
//  Created by Wood on 9/23/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import EditUserNameSceneAPI
import EditUserNameSceneEntity
import TDUtility

protocol EditUserNameSceneDataStore {
  var userName: String? { get set }
}

protocol EditUserNameSceneBusinessLogic {
  func setUserName()
  func verifyUserName(_ userName: String)
  func requestEditUserName(_ userName: String)

  func cancelAllTasks()
}

final class EditUserNameSceneInteractor: EditUserNameSceneDataStore {
  var userName: String?

  private var editUserNameTask: Task<Void, Never>?

  var presenter: EditUserNameScenePresentationLogic?
  private let editUserNameWorker: EditUserNameSceneWorkable

  init(editUserNameWorker: EditUserNameSceneWorkable) {
    self.editUserNameWorker = editUserNameWorker
  }

  deinit {
    self.cancelAllTasks()
  }
}

// MARK: - Request to worker

extension EditUserNameSceneInteractor: EditUserNameSceneBusinessLogic {
  func setUserName() {
    self.presenter?.presentUserName(self.userName)
  }

  func verifyUserName(_ userName: String) {
    let isValid = StringValidationChecker.isValidNickName(userName)
    self.presenter?.presentUserNameVerification(isValid: isValid)
  }

  func requestEditUserName(_ userName: String) {
    guard StringValidationChecker.isValidNickName(userName)
    else { return }

    self.editUserNameTask = Task { [weak self] in
      guard let self else { return }

      defer { self.editUserNameTask = nil }
      if Task.isCancelled { return }

      do {
        try await self.editUserNameWorker.requestEditUserName(userName)
        self.userName = userName

        try Task.checkCancellation()
        await self.presenter?.presentEditUserNameResult(nil)
      } catch let error {
        if error is CancellationError { return }
        await self.presenter?.presentEditUserNameResult(error)
      }
    }
  }
}

extension EditUserNameSceneInteractor {
  func cancelAllTasks() {
    self.editUserNameTask?.cancel()
  }
}
