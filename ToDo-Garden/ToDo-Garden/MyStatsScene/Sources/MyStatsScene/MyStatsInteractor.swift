//
//  MyStatsInteractor.swift
//  
//
//  Created by SONG on 11/13/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import MyStatsSceneAPI
import MyStatsSceneEntity

protocol MyStatsDataStore {
  // var name: String { get set }
}

protocol MyStatsBusinessLogic {
  func doSomething(request: MyStats.Something.Request)
}

class MyStatsInteractor: MyStatsDataStore {
  // var name: String = ""
  var presenter: MyStatsPresentationLogic?
  private let someWorker: MyStatsWorkable
  
  init(someWorker: MyStatsWorkable) {
    self.someWorker = someWorker
  }
}

// MARK: - Request to worker

extension MyStatsInteractor: MyStatsBusinessLogic {
  func doSomething(request: MyStats.Something.Request) {
    self.someWorker.doSomeWork()
    
    let response = MyStats.Something.Response()
    self.presenter?.presentSomething(response: response)
  }
}
