//
//  EditUserIntroductionScenePresenter.swift
//  
//
//  Created by Wood on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import EditUserIntroductionSceneEntity

// swiftlint:disable type_name
@MainActor
protocol EditUserIntroductionScenePresentationLogic {
  func presentUserIntroduction(_ introduction: String)
  func presentEmptyUserIntroduction()
  func presentIntroductionIsValid()
  func presentIntroductionIsInvalid()
  func presentEditUserIntroductionSuccess()
  func presentEditUserIntroductionError(_ error: Error)
}
// swiftlint:enable type_name

class EditUserIntroductionScenePresenter {
  weak var viewController: EditUserIntroductionSceneDisplayLogic?
}

// MARK: - Request to ViewController

extension EditUserIntroductionScenePresenter: EditUserIntroductionScenePresentationLogic {
  func presentUserIntroduction(_ introduction: String) {
    self.viewController?.displayUserIntroduction(introduction)
  }

  func presentEmptyUserIntroduction() {
    self.viewController?.displayEmptyUserIntroduction()
  }

  func presentIntroductionIsValid() {
    self.viewController?.displayUserIntroductionValid()
  }

  func presentIntroductionIsInvalid() {
    // TODO: - Display 로직 호출
  }

  func presentEditUserIntroductionSuccess() {
    // TODO: - Display 로직 호출
  }

  func presentEditUserIntroductionError(_ error: Error) {
    // TODO: - Display 로직 호출
  }
}
