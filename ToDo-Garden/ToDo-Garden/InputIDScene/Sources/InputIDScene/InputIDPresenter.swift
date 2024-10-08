//
//  InputIDPresenter.swift
//  
//
//  Created by SONG on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import InputIDSceneEntity

protocol InputIDPresentationLogic {
  func presentSomething(response: InputID.Something.Response)
}

class InputIDPresenter {
  weak var viewController: InputIDDisplayLogic?
}

// MARK: - Request to ViewController

extension InputIDPresenter: InputIDPresentationLogic {
  func presentSomething(response: InputID.Something.Response) {
    let viewModel = InputID.Something.ViewModel()
    self.viewController?.displaySomething(viewModel: viewModel)
  }
}
