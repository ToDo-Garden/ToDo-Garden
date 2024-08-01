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
}

protocol ManageGroupBusinessLogic {
  func fetchGroupList(request: ManageGroup.FetchGroupList.Request)
  func deleteGroup(request: ManageGroup.DeleteGroup.Request)
  func reorderGroup(request: ManageGroup.ReorderGroup.Request)
  func addReorderedGroups(
    id: String,
    sourceIndex: Int,
    destinationIndex: Int
  )
  func cancelEditing()
}

class ManageGroupInteractor: ManageGroupDataStore {
  var presenter: ManageGroupPresentationLogic?
  private let someWorker: FetchGroupListWorkable
  private let manageGroupWorker: ManageGroupWorkable
  
  init(
    worker: ManageGroupWorkable
  ) {
    self.manageGroupWorker = worker
  }
}

// MARK: - Request to worker

extension ManageGroupInteractor: ManageGroupBusinessLogic {
  func fetchGroupList(request: ManageGroup.FetchGroupList.Request) {
    self.manageGroupWorker.fetchGroupList(request: request)
    
    let response = ManageGroup.FetchGroupList.Response(with: "SomeResponse")
    self.presenter?.presentFetchedGroupList(response: response)
  }
  
  func deleteGroup(request: ManageGroup.DeleteGroup.Request) {
  }
  
  func reorderGroup(request: ManageGroup.ReorderGroup.Request) {
  }
  
  func cancelEditing() {
  }
  
  func addReorderedGroups(
    id: String,
    sourceIndex: Int,
    destinationIndex: Int
  ) {
  }
}
