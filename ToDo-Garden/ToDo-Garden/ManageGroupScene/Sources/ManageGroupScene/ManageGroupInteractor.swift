//
//  ManageGroupInteractor.swift
//  
//
//  Created by SONG on 6/26/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import ManageGroupSceneAPI
import ManageGroupSceneEntity

protocol ManageGroupDataStore {
  // var name: String { get set }
}

protocol ManageGroupBusinessLogic {
  func doSomething(request: ManageGroup.FetchGroupList.Request)
}

class ManageGroupInteractor: ManageGroupDataStore {
  // var name: String = ""
  var presenter: ManageGroupPresentationLogic?
  private let someWorker: FetchGroupListWorkable
  
  init(someWorker: FetchGroupListWorkable) {
    self.someWorker = someWorker
  }
}

// MARK: - Request to worker

extension ManageGroupInteractor: ManageGroupBusinessLogic {
  func doSomething(request: ManageGroup.FetchGroupList.Request) {
    self.someWorker.fetchGroupList(request: request)
    
    let response = ManageGroup.FetchGroupList.Response(with: "something")
    self.presenter?.presentSomething(response: response)
  }
}
