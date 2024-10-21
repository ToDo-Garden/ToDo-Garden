//
//  SignUpPresenter.swift
//  
//
//  Created by SONG on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SignUpSceneEntity

protocol SignUpPresentationLogic {
  func presentValidation(response: SignUp.CheckStringValidation.Response)
}

class SignUpPresenter {
  weak var viewController: SignUpDisplayLogic?
}

// MARK: - Request to ViewController

extension SignUpPresenter: SignUpPresentationLogic {
  func presentValidation(response: SignUp.CheckStringValidation.Response) {
    let viewModel = self.makeViewModel(response: response)
    self.viewController?.displayValidation(viewModel: viewModel)
  }
  
  private func makeViewModel(
    response: SignUp.CheckStringValidation.Response
  ) -> SignUp.CheckStringValidation.ViewModel {
    let viewModel = SignUp.CheckStringValidation.ViewModel(
      warningText: self.makeWarningText(currentPageIndex: response.currentPageIndex),
      isValid: self.isValid(
        currentPageIndex: response.currentPageIndex,
        validationState: response.validationState
      ),
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
  
  private func isValid(currentPageIndex: Int, validationState: SignUp.ValidationState) -> Bool {
    if currentPageIndex == 1 {
      switch validationState {
      case SignUp.ValidationState.invalid:
        return false
      default:
        return true
      }
    } else {
      switch validationState {
      case SignUp.ValidationState.valid:
        return true
      default:
        return false
      }
    }
  }
}
