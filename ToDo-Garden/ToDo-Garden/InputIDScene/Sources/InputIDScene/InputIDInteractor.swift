//
//  InputIDInteractor.swift
//  
//
//  Created by SONG on 10/6/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import InputIDSceneAPI
import InputIDSceneEntity

protocol InputIDDataStore {
  // var name: String { get set }
}

protocol InputIDBusinessLogic {
  func doSomething(request: InputID.Something.Request)
}

class InputIDInteractor: InputIDDataStore {
  // var name: String = ""
  var presenter: InputIDPresentationLogic?
  private let someWorker: InputIDWorkable
  
  init(someWorker: InputIDWorkable) {
    self.someWorker = someWorker
  }
}

// MARK: - Request to worker

extension InputIDInteractor: InputIDBusinessLogic {
  func doSomething(request: InputID.Something.Request) {
    self.someWorker.doSomeWork()
    
    let response = InputID.Something.Response()
    self.presenter?.presentSomething(response: response)
  }
}
