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
  func doSomething(request: SignUp.Something.Request)
}

class SignUpInteractor: SignUpDataStore {
  // var name: String = ""
  var presenter: SignUpPresentationLogic?
  private let someWorker: SignUpWorkable
  
  init(someWorker: SignUpWorkable) {
    self.someWorker = someWorker
  }
}

// MARK: - Request to worker

extension SignUpInteractor: SignUpBusinessLogic {
  func doSomething(request: SignUp.Something.Request) {
    self.someWorker.doSomeWork()
    
    let response = SignUp.Something.Response()
    self.presenter?.presentSomething(response: response)
  }
}
