//
//  PostGroupWorker.swift
//
//
//  Created by SONG on 7/8/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit.UIColor

import PostGroupSceneAPI
import PostGroupSceneEntity

public struct PostGroupWorker: PostGroupWorkable {
  public init() {}
  
  public func touchDoneButton(groupID: UUID?, groupName: String, groupColor: UIColor) -> PostGroup.ToDoGroup {
    let group = PostGroup.ToDoGroup(groupID: groupID, groupName: groupName, groupColor: groupColor)
    return group
  }
}
