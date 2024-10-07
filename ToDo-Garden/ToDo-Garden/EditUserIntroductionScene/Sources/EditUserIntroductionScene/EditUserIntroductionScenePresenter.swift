//
//  EditUserIntroductionScenePresenter.swift
//  
//
//  Created by Wood on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

// swiftlint:disable type_name
protocol EditUserIntroductionScenePresentationLogic {
  func presentSomething(response: EditUserIntroductionScene.Something.Response)
}
// swiftlint:enable type_name

class EditUserIntroductionScenePresenter {
  weak var viewController: EditUserIntroductionSceneDisplayLogic?
}

// MARK: - Request to ViewController

extension EditUserIntroductionScenePresenter: EditUserIntroductionScenePresentationLogic {
  func presentSomething(response: EditUserIntroductionScene.Something.Response) {
    let viewModel = EditUserIntroductionScene.Something.ViewModel()
    self.viewController?.displaySomething(viewModel: viewModel)
  }
}
