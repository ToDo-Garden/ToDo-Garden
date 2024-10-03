//
//  LoginInteractor.swift
//  
//
//  Created by SONG on 10/2/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import LoginSceneAPI
import LoginSceneEntity

protocol LoginDataStore {
  // var name: String { get set }
}

protocol LoginBusinessLogic {
  func doSomething(request: Login.Something.Request)
}

class LoginInteractor: LoginDataStore {
  // var name: String = ""
  var presenter: LoginPresentationLogic?
  private let someWorker: LoginWorkable
  
  init(someWorker: LoginWorkable) {
    self.someWorker = someWorker
  }
}

// MARK: - Request to worker

extension LoginInteractor: LoginBusinessLogic {
  func doSomething(request: Login.Something.Request) {
    self.someWorker.doSomeWork()
    
    let response = Login.Something.Response()
    self.presenter?.presentSomething(response: response)
  }
}
