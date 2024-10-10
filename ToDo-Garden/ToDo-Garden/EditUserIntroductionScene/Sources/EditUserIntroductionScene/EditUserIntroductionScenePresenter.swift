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
    // TODO: - Display 로직 호출
  }

  func presentEmptyUserIntroduction() {
    // TODO: - Display 로직 호출
  }

  func presentIntroductionIsValid() {
    // TODO: - Display 로직 호출
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
