//
//  ManageGroupWorkable.swift
//
//
//  Created by SONG on 8/1/24.
//

import Foundation

import ManageGroupSceneEntity

public protocol ManageGroupWorkable {
  func fetchGroupList(
    request: ManageGroupSceneEntity.ManageGroup.FetchGroupList.Request
  ) async -> Result<[ManageGroup.ToDoGroup], Error>
  func saveGroupList(
    request: ManageGroupSceneEntity.ManageGroup.SaveGroupList.Request
  ) async -> Result<[ManageGroup.ToDoGroup], Error>
}
