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
  func fetchGroupList(request: ManageGroup.FetchGroupList.Request) async
  func saveGroupList(request: ManageGroup.SaveGroupList.Request) async
  func deleteGroup(request: ManageGroup.DeleteGroup.Request)
}

class ManageGroupInteractor: ManageGroupDataStore {
  var presenter: ManageGroupPresentationLogic?
  private let manageGroupWorker: ManageGroupWorkable
  var currentGroups: [ManageGroup.ToDoGroup]
  
  init(
    worker: ManageGroupWorkable
  ) {
    self.manageGroupWorker = worker
    self.currentGroups = []
  }
}

// MARK: - Request to worker

extension ManageGroupInteractor: ManageGroupBusinessLogic {
  func fetchGroupList(request: ManageGroup.FetchGroupList.Request) async {
    let result = await self.manageGroupWorker.fetchGroupList(request: request)
    switch result {
    case .success(let groups):
      self.currentGroups = groups
      let response = ManageGroup.FetchGroupList.Response(with: groups)
      self.presenter?.presentFetchedGroupList(response: response)
    case .failure(let error):
      print("Error fetching group list: \(error)")
    }
  }
  
  func saveGroupList(request: ManageGroupSceneEntity.ManageGroup.SaveGroupList.Request) async {
    let result = await self.manageGroupWorker.saveGroupList(request: request)
    switch result {
    case .success(let groups):
      self.currentGroups = groups
      let response = ManageGroup.SaveGroupList.Response(with: groups)
      self.presenter?.presentSavedGroupList(response: response)
    case .failure(let error):
      print("Error fetching group list: \(error)")
    }
  }
  
  func deleteGroup(request: ManageGroup.DeleteGroup.Request) {
    self.currentGroups.remove(at: request.index)
    let response = ManageGroup.DeleteGroup.Response(id: request.id, index: request.index)
    self.presenter?.presentDeletedGroup(response: response)
  }
}
