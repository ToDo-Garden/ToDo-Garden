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
    // 서버에 그룹 변경을 요청
    // groupID가 nil 경우, 그룹추가하기
    // groupID가 not nil 경우, 그룹편집하기
    let group = PostGroup.ToDoGroup(groupID: groupID, groupName: groupName, groupColor: groupColor)
    return group
  }
}
