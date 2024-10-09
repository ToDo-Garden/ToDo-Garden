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

protocol EditUserIntroductionSceneBusinessLogic {
  func loadUserIntroduction()
  func verifyUserIntroduction(_ introduction: String)
}

final class EditUserIntroductionSceneInteractor: EditUserIntroductionSceneDataStore {
  var userIntroduction: String?

  var presenter: EditUserIntroductionScenePresentationLogic?
  private let someWorker: EditUserIntroductionSceneWorkable

  init(someWorker: EditUserIntroductionSceneWorkable) {
    self.someWorker = someWorker
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
}

// MARK: - Private Functions

extension EditUserIntroductionSceneInteractor {
  private func checkUserIntroductionValidity(_ introduction: String) -> Bool {
    return introduction.count <= 15
  }
}
