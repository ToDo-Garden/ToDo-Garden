//
//  DeleteGroupWorkable.swift
//
//
//  Created by SONG on 7/1/24.
//

import Foundation

import ManageGroupSceneEntity

public protocol DeleteGroupWorkable {
  func deleteGroup(request: ManageGroup.DeleteGroup.Request)
}
