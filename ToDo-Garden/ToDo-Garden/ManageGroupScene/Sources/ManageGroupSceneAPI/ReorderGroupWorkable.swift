//
//  ReorderGroupWorkable.swift
//
//
//  Created by SONG on 7/2/24.
//

import Foundation

import ManageGroupSceneEntity

public protocol ReorderGroupWorkable {
  func reorderGroup(request: ManageGroup.ReorderGroup.Request)
}
