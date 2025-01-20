//
//  EditUserIntroductionScenePresenter.swift
//
//
//  Created by Wood on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import EditUserIntroductionSceneEntity
import HTTPClientAPI

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
    self.viewController?.displayEditUserIntroductionFailure(error.localizedDescription)
  }
}
