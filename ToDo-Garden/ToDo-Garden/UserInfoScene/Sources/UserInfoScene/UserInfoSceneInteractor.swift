//
//  UserInfoSceneInteractor.swift
//  
//
//  Created by Wood on 8/28/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import UserInfoSceneAPI
import UserInfoSceneEntity

protocol UserInfoSceneDataStore {
  // var name: String { get set }
}

protocol UserInfoSceneBusinessLogic {
  func doSomething(request: UserInfoScene.Something.Request)
}

class UserInfoSceneInteractor: UserInfoSceneDataStore {
  // var name: String = ""
  var presenter: UserInfoScenePresentationLogic?
  private let userInfoWorker: UserInfoSceneWorkable
  
  init(userInfoWorker: UserInfoSceneWorkable) {
    self.userInfoWorker = userInfoWorker
  }
}

// MARK: - Request to worker

extension UserInfoSceneInteractor: UserInfoSceneBusinessLogic {
  func doSomething(request: UserInfoScene.Something.Request) {
    self.userInfoWorker.doSomeWork()
    
    let response = UserInfoScene.Something.Response()
    self.presenter?.presentSomething(response: response)
  }
}
