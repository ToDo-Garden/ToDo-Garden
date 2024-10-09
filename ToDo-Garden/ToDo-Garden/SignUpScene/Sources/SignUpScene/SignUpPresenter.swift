//
//  SignUpPresenter.swift
//  
//
//  Created by SONG on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SignUpSceneEntity

protocol SignUpPresentationLogic {
  func presentSomething(response: SignUp.Something.Response)
}

class SignUpPresenter {
  weak var viewController: SignUpDisplayLogic?
}

// MARK: - Request to ViewController

extension SignUpPresenter: SignUpPresentationLogic {
  func presentSomething(response: SignUp.Something.Response) {
    let viewModel = SignUp.Something.ViewModel()
    self.viewController?.displaySomething(viewModel: viewModel)
  }
}
