//
//  ManageGroupInteractor.swift
//
//
//  Created by SONG on 6/26/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import HTTPClientAPI
import ManageGroupSceneAPI
import ManageGroupSceneEntity

protocol ManageGroupDataStore {
}

@MainActor
protocol ManageGroupBusinessLogic {
  func fetchGroupList(request: ManageGroup.FetchGroupList.Request)
  func saveGroupList(request: ManageGroup.SaveGroupList.Request)
  func deleteGroup(request: ManageGroup.DeleteGroup.Request)
  func addGroup(request: ManageGroup.AddGroup.Request)
  func editGroup(request: ManageGroup.EditGroup.Request)
  func addGroupDirectly(request: ManageGroup.AddGroup.Request)
  func cancelTask(for key: ManageGroupInteractor.TaskKey)
}

class ManageGroupInteractor: ManageGroupDataStore {
  var presenter: ManageGroupPresentationLogic?
  private let manageGroupWorker: ManageGroupWorkable
  
  var currentGroups: [ManageGroup.ToDoGroup]
  private var tasks: [ManageGroupInteractor.TaskKey: Task<Void, Never>] = [:]
  
  init(
    worker: ManageGroupWorkable
  ) {
    self.manageGroupWorker = worker
    self.currentGroups = []
  }
  
  func cancelTask(for key: ManageGroupInteractor.TaskKey) {
    self.tasks[key]?.cancel()
    self.tasks[key] = nil
  }
}

// MARK: - Request to worker

extension ManageGroupInteractor: ManageGroupBusinessLogic {
  func fetchGroupList(request: ManageGroup.FetchGroupList.Request) {
    self.tasks[TaskKey.fetchGroups] = Task {
      defer { self.tasks[TaskKey.fetchGroups] = nil }
      
      do {
        try Task.checkCancellation()
        let result = try await self.manageGroupWorker.fetchGroupList(request: request)
        try Task.checkCancellation()
        self.currentGroups = result
        let response = ManageGroup.FetchGroupList.Response(with: result)
        self.presenter?.presentFetchedGroupList(response: response)
      } catch let error {
        self.handleError(error, about: TaskKey.fetchGroups)
      }
    }
  }
  
  func saveGroupList(request: ManageGroupSceneEntity.ManageGroup.SaveGroupList.Request) {
    self.tasks[TaskKey.saveGroups] = Task {
      defer { self.tasks[TaskKey.saveGroups] = nil }
      
      do {
        try Task.checkCancellation()
        let result = try await self.manageGroupWorker.saveGroupList(request: request)
        try Task.checkCancellation()
        self.currentGroups = result
        let response = ManageGroup.SaveGroupList.Response(with: result)
        self.presenter?.presentSavedGroupList(response: response)
      } catch let error {
        self.handleError(error, about: TaskKey.saveGroups)
      }
    }
  }
  
  func addGroupDirectly(request: ManageGroup.AddGroup.Request) {
    self.tasks[TaskKey.addGroupDirectly] = Task {
      defer { self.tasks[TaskKey.addGroupDirectly] = nil }
      
      do {
        if self.isFull() { throw NSError(domain: "list is Full (less than 51)", code: 1) }
        
        try Task.checkCancellation()
        let groupID = try await self.manageGroupWorker.addGroupDirectly(request: request)
        try Task.checkCancellation()
        
        let group = ManageGroup.ToDoGroup(
          groupID: groupID,
          groupName: request.groupName,
          progressColor: request.groupColor,
          progressRate: Float.zero
        )
        self.currentGroups.append(group)
        let response = ManageGroup.AddGroup.Response(group: group)
        self.presenter?.presentAddedGroup(response: response)
      } catch let error {
        self.handleError(error, about: TaskKey.addGroupDirectly)
      }
    }
  }
  
  func deleteGroup(request: ManageGroup.DeleteGroup.Request) {
    self.currentGroups.remove(at: request.index)
    let response = ManageGroup.DeleteGroup.Response(groupID: request.groupID, index: request.index)
    self.presenter?.presentDeletedGroup(response: response)
  }
  
  func addGroup(request: ManageGroup.AddGroup.Request) {
    if self.isFull() {
      let error = NSError(domain: "list is Full (less than 51)", code: 1)
      self.handleError(error, about: TaskKey.none)
    }
    
    let group = self.manageGroupWorker.addGroup(request: request)
    
    self.currentGroups.append(group)
    let response = ManageGroup.AddGroup.Response(group: group)
    self.presenter?.presentAddedGroup(response: response)
  }
  
  func editGroup(request: ManageGroup.EditGroup.Request) {
    if let index = self.currentGroups.firstIndex(where: { $0.groupID == request.groupID }) {
      let progressRate = self.currentGroups[index].progressRate
      let group = self.manageGroupWorker.editGroup(request: request, progressRate: progressRate)
      self.currentGroups[index] = group
      
      let response = ManageGroup.EditGroup.Response(group: group, editedIndex: index)
      self.presenter?.presentEditedGroup(response: response)
    } else {
      return
    }
  }
}

extension ManageGroupInteractor {
  enum TaskKey {
    case fetchGroups
    case saveGroups
    case addGroupDirectly
    case none
  }
  
  @MainActor
  private func handleError(_ error: Error, about task: TaskKey) {
    debugPrint("Error: \(error)")
    if task == .saveGroups {
      self.presenter?.presentFailedToSaveGroupList()
    }
    
    if error is CancellationError {
      return
    } else if error is HTTPClientError {
      return
    } else {
      return
    }
  }
  
  private func isFull() -> Bool {
    return self.currentGroups.count >= 50
  }
}
