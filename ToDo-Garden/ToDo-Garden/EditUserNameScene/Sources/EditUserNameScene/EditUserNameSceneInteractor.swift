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
  func requestEditUserName(_ userName: String)
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
    self.editUserNameTask?.cancel()
  }
}

// MARK: - Request to worker

extension EditUserNameSceneInteractor: EditUserNameSceneBusinessLogic {
  func setUserName() {
    self.presenter?.presentUserName(self.userName)
  }

  func verifyUserName(_ userName: String) {
    let isValid = self.isValidNickname(userName)
    self.presenter?.presentUserNameVerification(isValid: isValid)
  }

  func requestEditUserName(_ userName: String) {
    guard self.isValidNickname(userName)
    else { return }

    self.editUserNameTask = Task { [weak self] in
      guard let self else { return }

      defer { self.editUserNameTask = nil }
      if Task.isCancelled { return }

      do {
        try await self.editUserNameWorker.requestEditUserName(userName)

        try Task.checkCancellation()
        await self.presenter?.presentEditUserNameResult(nil)
      } catch let error {
        if error as? CancellationError != nil { return }
        await self.presenter?.presentEditUserNameResult(error)
      }
    }
  }
}

extension EditUserNameSceneInteractor {
  private func isValidNickname(_ nickName: String) -> Bool {
    let regexPattern = "^[\\p{L}\\p{N}]{5,12}$"
    let result = nickName.range(of: regexPattern, options: String.CompareOptions.regularExpression)
    return result != nil
  }
}
