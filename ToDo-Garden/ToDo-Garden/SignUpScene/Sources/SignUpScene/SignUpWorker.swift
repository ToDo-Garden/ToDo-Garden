//
//  SignUpWorker.swift
//
//
//  Created by SONG on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SignUpSceneAPI
import SignUpSceneEntity
import TDUtility

public struct SignUpWorker: SignUpWorkable {
  public init() {}
  
  public func checkStringValidation(text: String?, currentPageIndex: Int) -> SignUp.ValidationState {
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
}
