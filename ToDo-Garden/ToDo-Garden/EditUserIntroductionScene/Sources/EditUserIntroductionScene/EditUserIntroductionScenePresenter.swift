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
  func presentUserIntroduction(_ introduction: String?)
  func presentUserNameVerification(isValid: Bool)
  func presentEditUserIntroductionResult(_ error: Error?)
}
// swiftlint:enable type_name

class EditUserIntroductionScenePresenter {
  weak var viewController: EditUserIntroductionSceneDisplayLogic?
}

// MARK: - Request to ViewController

extension EditUserIntroductionScenePresenter: EditUserIntroductionScenePresentationLogic {
  func presentUserIntroduction(_ introduction: String?) {
    // TODO: - Display 로직 호출
  }

  func presentUserNameVerification(isValid: Bool) {
    // TODO: - Display 로직 호출
  }

  func presentEditUserIntroductionResult(_ error: Error?) {
    // TODO: - Display 로직 호출
  }
}
