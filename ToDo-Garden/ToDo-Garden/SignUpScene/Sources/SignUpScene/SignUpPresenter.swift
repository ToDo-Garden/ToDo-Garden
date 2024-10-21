//
//  SignUpPresenter.swift
//  
//
//  Created by SONG on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SignUpSceneEntity

protocol SignUpPresentationLogic {
  func presentValid(response: SignUp.CheckStringValidation.Response)
  func presentInvalid(response: SignUp.CheckStringValidation.Response)
}

class SignUpPresenter {
  weak var viewController: SignUpDisplayLogic?
}

// MARK: - Request to ViewController

extension SignUpPresenter: SignUpPresentationLogic {
  func presentValid(response: SignUp.CheckStringValidation.Response) {
    let viewModel = SignUp.CheckStringValidation.ViewModel(warningText: "", currentPageIndex: response.currentPageIndex)
    self.viewController?.displayValid(viewModel: viewModel)
  }
  
  func presentInvalid(response: SignUp.CheckStringValidation.Response) {
    let viewModel = SignUp.CheckStringValidation.ViewModel(
      warningText: self.makeWarningText(currentPageIndex: response.currentPageIndex),
      currentPageIndex: response.currentPageIndex
    )
    self.viewController?.displayInvalid(viewModel: viewModel)
  }
  
  private func makeViewModel(
    response: SignUp.CheckStringValidation.Response
  ) -> SignUp.CheckStringValidation.ViewModel {
    let viewModel = SignUp.CheckStringValidation.ViewModel(
      warningText: self.makeWarningText(currentPageIndex: response.currentPageIndex),
      currentPageIndex: response.currentPageIndex
    )
    return viewModel
  }
  
  private func makeWarningText(currentPageIndex: Int) -> String {
    switch currentPageIndex {
    case 0:
      return Constant.ScrollView.SignUpInputView.StringLiteral.conditionsForIDGenerationWarning
    case 1:
      return Constant.ScrollView.SignUpInputView.StringLiteral.introductionWarning
    case 2:
      return Constant.ScrollView.SignUpInputView.StringLiteral.nicknameWarning
    default:
      return ""
    }
  }
}
