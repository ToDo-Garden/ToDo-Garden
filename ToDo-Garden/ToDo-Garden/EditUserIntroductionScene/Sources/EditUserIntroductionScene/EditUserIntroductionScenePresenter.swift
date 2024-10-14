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

final class EditUserIntroductionScenePresenter {
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
    self.viewController?.displayUserIntroductionInvalid()
  }

  func presentEditUserIntroductionSuccess() {
    self.viewController?.displayEditUserIntroductionSuccess()
  }

  func presentEditUserIntroductionError(_ error: Error) {
    // TODO: ToDoGardenAlertController에 Model 추가 후 구현 예정입니다. 에러 발생시 알럿에 표시할 문자열을 Display 로직으로 전달합니다.
//    self.viewController?.displayEditUserIntroductionFailure(error.localizedDescription)
  }
}
