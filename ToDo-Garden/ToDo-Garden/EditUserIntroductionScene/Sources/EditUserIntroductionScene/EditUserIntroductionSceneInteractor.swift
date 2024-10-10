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
  /// UserInfoScene에서 Payload로 런타임에 전달받을 한줄 소개에 대한 데이터입니다.
  var userIntroduction: String? { get }
}

@MainActor
protocol EditUserIntroductionSceneBusinessLogic {
  func loadUserIntroduction()
  func verifyUserIntroduction(_ introduction: String)
  func requestEditUserIntroduction(_ introduction: String)

  func cancelRunningTask()
}

final class EditUserIntroductionSceneInteractor: EditUserIntroductionSceneDataStore {
  var userIntroduction: String?

  private var requestEditUserIntroductionTask: Task<Void, Never>?

  var presenter: EditUserIntroductionScenePresentationLogic?
  private let editUserIntroductionWorker: EditUserIntroductionSceneWorkable

  init(editUserIntroductionWorker: EditUserIntroductionSceneWorkable) {
    self.editUserIntroductionWorker = editUserIntroductionWorker
  }
}

// MARK: - Request to worker

extension EditUserIntroductionSceneInteractor: EditUserIntroductionSceneBusinessLogic {
  func loadUserIntroduction() {
    self.presenter?.presentUserIntroduction(self.userIntroduction)
  }

  func verifyUserIntroduction(_ introduction: String) {
    let isValid = self.checkUserIntroductionValidity(introduction)
    self.presenter?.presentUserNameVerification(isValid: isValid)
  }

  func requestEditUserIntroduction(_ introduction: String) {
    guard self.checkUserIntroductionValidity(introduction)
    else { return }

    self.requestEditUserIntroductionTask = Task { [weak self] in
      guard let self else { return }

      defer { self.requestEditUserIntroductionTask = nil }
      if Task.isCancelled { return }

      do {
        try await self.editUserIntroductionWorker.editUserIntroduction(introduction)

        try Task.checkCancellation()
        self.presenter?.presentEditUserIntroductionSuccess()
      } catch let error {
        if error is CancellationError { return }
        self.presenter?.presentEditUserIntroductionError(error)
      }
    }
  }

  func cancelRunningTask() {
    self.requestEditUserIntroductionTask?.cancel()
  }
}

// MARK: - Private Functions

extension EditUserIntroductionSceneInteractor {
  private func checkUserIntroductionValidity(_ introduction: String) -> Bool {
    return introduction.count <= 15
  }
}
