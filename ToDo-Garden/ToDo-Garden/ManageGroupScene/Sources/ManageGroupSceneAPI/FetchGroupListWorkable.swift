//
//  ManageGroupWorkable.swift
//  
//
//  Created by SONG on 6/26/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import ManageGroupSceneEntity

public protocol FetchGroupListWorkable {
  func fetchGroupList(request: ManageGroup.FetchGroupList.Request)
}
