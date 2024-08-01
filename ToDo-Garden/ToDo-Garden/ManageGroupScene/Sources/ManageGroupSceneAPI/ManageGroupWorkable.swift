//
//  ManageGroupWorkable.swift
//
//
//  Created by SONG on 8/1/24.
//

import Foundation

import ManageGroupSceneEntity

public protocol ManageGroupWorkable {
  func fetchGroupList(request: ManageGroup.FetchGroupList.Request)
  func reorderGroup(request: ManageGroup.ReorderGroup.Request)
  func deleteGroup(request: ManageGroup.DeleteGroup.Request)
}
