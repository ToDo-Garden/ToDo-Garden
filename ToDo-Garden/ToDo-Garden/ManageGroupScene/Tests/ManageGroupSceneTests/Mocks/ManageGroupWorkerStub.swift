//
//  ManageGroupWorkerStub.swift
//  ManageGroupScene
//
//  Created by SONG on 2/8/25.
//

// swiftlint: disable all
import Foundation

import HTTPClientAPI
import ManageGroupSceneAPI
import ManageGroupSceneEntity

class ManageGroupWorkerStub {
  private var fetchedGroupList: [ManageGroupSceneEntity.ManageGroup.ToDoGroup] = []
  private var savedGroupList: [ManageGroupSceneEntity.ManageGroup.ToDoGroup] = []
  private var addedGroup: ManageGroupSceneEntity.ManageGroup.ToDoGroup?
  private var editedGroup: ManageGroupSceneEntity.ManageGroup.ToDoGroup?
  private var directAddedGroupID: UUID?
  private var error: HTTPClientError?
  
  func reset() {
    self.fetchedGroupList = []
    self.savedGroupList = []
    self.addedGroup = nil
    self.editedGroup = nil
    self.directAddedGroupID = nil
    self.error = nil
  }
  
  func setFetchedGroupList(_ fetchedGroupList: [ManageGroupSceneEntity.ManageGroup.ToDoGroup]) {
    self.fetchedGroupList = fetchedGroupList
  }
  
  func setSaveGroupList(_ savedGroupList: [ManageGroupSceneEntity.ManageGroup.ToDoGroup]) {
    self.savedGroupList = savedGroupList
  }
  
  func setAddedGroup(_ addedGroup: ManageGroupSceneEntity.ManageGroup.ToDoGroup) {
    self.addedGroup = addedGroup
  }
  
  func setEditedGroup(_ editedGroup: ManageGroupSceneEntity.ManageGroup.ToDoGroup) {
    self.editedGroup = editedGroup
  }
  
  func setDirectAddedGroupID(_ directAddedGroupID: UUID) {
    self.directAddedGroupID = directAddedGroupID
  }
  
  func setError(_ error: HTTPClientError) {
    self.error = error
  }
}

extension ManageGroupWorkerStub: ManageGroupWorkable {
  func fetchGroupList(request: ManageGroupSceneEntity.ManageGroup.FetchGroupList.Request) async throws -> [ManageGroupSceneEntity.ManageGroup.ToDoGroup] {
    if let error = self.error {
      throw error
    }
    return self.fetchedGroupList
  }
  
  func saveGroupList(request: ManageGroupSceneEntity.ManageGroup.SaveGroupList.Request) async throws -> [ManageGroupSceneEntity.ManageGroup.ToDoGroup] {
    if let error = self.error {
      throw error
    }

    return self.savedGroupList
  }
  
  func addGroup(request: ManageGroupSceneEntity.ManageGroup.AddGroup.Request) -> ManageGroupSceneEntity.ManageGroup.ToDoGroup {
    return self.addedGroup!
  }
  
  func editGroup(request: ManageGroupSceneEntity.ManageGroup.EditGroup.Request, progressRate: Float) -> ManageGroupSceneEntity.ManageGroup.ToDoGroup {
    return self.editedGroup!
  }
  
  func addGroupDirectly(request: ManageGroupSceneEntity.ManageGroup.AddGroup.Request) async throws -> UUID {
    if let error = self.error {
      throw error
    }
    
    if let groupID = self.directAddedGroupID {
      return groupID
    }

    throw NSError(domain: "Test Unknown Error", code: -1)
  }
}
// swiftlint: enable all
