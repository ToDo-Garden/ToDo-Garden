//
//  EditUserIntroductionScenePresenter.swift
//  
//
//  Created by Wood on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import EditUserIntroductionSceneEntity

// swiftlint:disable type_name
protocol EditUserIntroductionScenePresentationLogic {
  func presentUserIntroduction(_ introduction: String?)
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
}
