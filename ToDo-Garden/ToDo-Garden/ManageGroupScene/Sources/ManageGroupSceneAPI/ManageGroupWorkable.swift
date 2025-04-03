//
//  ManageGroupWorkable.swift
//
//
//  Created by SONG on 8/1/24.
//

import Foundation

import HTTPClientAPI
import ManageGroupSceneEntity

public protocol ManageGroupWorkable {
  func fetchGroupList(
    request: ManageGroupSceneEntity.ManageGroup.FetchGroupList.Request
  ) async throws -> [ManageGroup.ToDoGroup]
  func saveGroupList(
    request: ManageGroupSceneEntity.ManageGroup.SaveGroupList.Request
  ) async throws -> [ManageGroup.ToDoGroup]
  func addGroup(request: ManageGroup.AddGroup.Request) -> ManageGroup.ToDoGroup
  func editGroup(
    request: ManageGroup.EditGroup.Request,
    progressRate: Float
  ) -> ManageGroup.ToDoGroup
  func addGroupDirectly(request: ManageGroup.AddGroup.Request) async throws -> UUID
  func fetchGroupListFromGRDB() async throws -> [ManageGroup.ToDoGroup]
  func saveGroupListToGRDB(request: ManageGroup.SaveGroupList.Request) async throws -> [ManageGroup.ToDoGroup]
}
