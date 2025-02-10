//
//  Untitled.swift
//  SignUpScene
//
//  Created by SONG on 2/10/25.
//

// swiftlint:disable all
@testable import SignUpScene
import SignUpSceneAPI
import SignUpSceneEntity

final class SignUpDisplayLogicStub: SignUpDisplayLogic {
  var isValidString: Bool? = nil
  var isRegistrationSuccess: Bool? = nil
  var catchedError: Error? = nil
  
  func displayValid(viewModel: SignUpSceneEntity.SignUp.CheckStringValidation.ViewModel) {
    self.isValidString = true
  }
  
  func displayInvalid(viewModel: SignUpSceneEntity.SignUp.CheckStringValidation.ViewModel) {
    self.isValidString = false
  }
  
  func displayUserRegistrationSuccess(viewModel: SignUpSceneEntity.SignUp.RegisterUser.ViewModel) {
    self.isRegistrationSuccess = viewModel.isSuccess
  }
  
  func displayErrorInfoToast(error: any Error) {
    self.isRegistrationSuccess = false
    self.catchedError = error
  }
}

extension SignUpDisplayLogicStub {
  func reset() {
    self.isValidString = nil
    self.isRegistrationSuccess = nil
    self.catchedError = nil
  }
}
// swiftlint:enable all
