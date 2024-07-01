//
//  EditToDoInteractor.swift
//  
//
//  Created by Wood on 6/29/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import EditToDoSceneAPI
import EditToDoSceneEntity

protocol EditToDoDataStore {
  // var name: String { get set }
}

protocol EditToDoBusinessLogic {
  func doSomething(request: EditToDo.Something.Request)
}

class EditToDoInteractor: EditToDoDataStore {
  // var name: String = ""
  var presenter: EditToDoPresentationLogic?
  private let someWorker: EditToDoWorkable
  
  init(someWorker: EditToDoWorkable) {
    self.someWorker = someWorker
  }
}

// MARK: - Request to worker

extension EditToDoInteractor: EditToDoBusinessLogic {
  func doSomething(request: EditToDo.Something.Request) {
    self.someWorker.doSomeWork()
    
    let response = EditToDo.Something.Response()
    self.presenter?.presentSomething(response: response)
  }
}
