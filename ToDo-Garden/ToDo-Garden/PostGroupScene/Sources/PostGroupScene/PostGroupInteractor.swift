//
//  PostGroupInteractor.swift
//  
//
//  Created by SONG on 7/8/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import PostGroupSceneAPI
import PostGroupSceneEntity

protocol PostGroupDataStore {
  // var name: String { get set }
}

protocol PostGroupBusinessLogic {
  func doSomething(request: PostGroup.Something.Request)
}

class PostGroupInteractor: PostGroupDataStore {
  // var name: String = ""
  var presenter: PostGroupPresentationLogic?
  private let someWorker: PostGroupWorkable
  
  init(someWorker: PostGroupWorkable) {
    self.someWorker = someWorker
  }
}

// MARK: - Request to worker

extension PostGroupInteractor: PostGroupBusinessLogic {
  func doSomething(request: PostGroup.Something.Request) {
    self.someWorker.doSomeWork()
    
    let response = PostGroup.Something.Response()
    self.presenter?.presentSomething(response: response)
  }
}
