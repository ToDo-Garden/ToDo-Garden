//
//  SignUpWorkerStub.swift
//  SignUpScene
//
//  Created by SONG on 2/10/25.
//
// swiftlint:disable all
import Foundation

import SignUpSceneAPI
import SignUpSceneEntity
import TDUtility

final class SignUpWorkerStub {
  private var isExistedUserID: Bool = false
  private var error: Error? = nil

  
  func setError() {
    self.error = NSError(domain: "testError", code: 0)
  }
  
  func setErrorAboutExistingID() {
    self.error = NSError(domain: "testError", code: 0)
    self.isExistedUserID = true
  }
  
  func reset() {
    self.isExistedUserID = false
    self.error = nil
  }
}

extension SignUpWorkerStub: SignUpWorkable {
  func checkStringValidation(text: String?, currentPageIndex: Int) -> SignUp.ValidationState {
    guard let text else {
      return SignUp.ValidationState.empty
    }
    switch currentPageIndex {
    case 0:
      if StringValidationChecker.isValidID(text) {
        return SignUp.ValidationState.valid
      } else {
        return SignUp.ValidationState.invalid
      }
    case 1:
      if StringValidationChecker.isValidIntroduction(text) {
        return SignUp.ValidationState.valid
      } else {
        return SignUp.ValidationState.invalid
      }
    case 2:
      if StringValidationChecker.isValidNickName(text) {
        return SignUp.ValidationState.valid
      } else {
        return SignUp.ValidationState.invalid
      }
    default:
      return SignUp.ValidationState.empty
    }
  }
  
  func registerUser(request: SignUp.RegisterUser.Request) async throws -> SignUp.RegisterUser.Response {
    guard (self.error == nil) else {
      if self.isExistedUserID == true {
        throw SignUp.SignUpError.userIDAlreadyExisted
      } else {
        throw self.error!
      }
    }
  
    return SignUp.RegisterUser.Response(isSuccess: true)
  }
}
// swiftlint:enable all
