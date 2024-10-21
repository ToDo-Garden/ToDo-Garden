//
//  SignUpInteractor.swift
//
//
//  Created by SONG on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SignUpSceneAPI
import SignUpSceneEntity

protocol SignUpDataStore {
  // var name: String { get set }
}

protocol SignUpBusinessLogic {
  func checkStringValidation(request: SignUp.CheckStringValidation.Request)
}

class SignUpInteractor: SignUpDataStore {
  // var name: String = ""
  var presenter: SignUpPresentationLogic?
  private let signUpWorker: SignUpWorkable
  
  // TODO: 파라미터 명 바꾸기
  init(someWorker: SignUpWorkable) {
    self.signUpWorker = someWorker
  }
}

// MARK: - Request to worker

extension SignUpInteractor: SignUpBusinessLogic {
  func checkStringValidation(request: SignUp.CheckStringValidation.Request) {
    let state = self.signUpWorker.checkStringValidation(text: request.text, currentPageIndex: request.currentPageIndex)
    
    let response = SignUp.CheckStringValidation.Response(
      validationState: state,
      currentPageIndex: request.currentPageIndex
    )
    
    switch state {
    case SignUp.ValidationState.valid:
      self.presenter?.presentValid(response: response)
    case SignUp.ValidationState.invalid:
      self.presenter?.presentInvalid(response: response)
    case SignUp.ValidationState.empty:
      if request.currentPageIndex == 1 {
        self.presenter?.presentValid(response: response)
      } else {
        self.presenter?.presentInvalid(response: response)
      }
    }
  }
}
