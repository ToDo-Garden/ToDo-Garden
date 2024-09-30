//
//  PostGroupWorkable.swift
//  
//
//  Created by SONG on 7/8/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit.UIColor

import PostGroupSceneEntity

public protocol PostGroupWorkable {
  func touchDoneButton(
    groupID: UUID?,
    groupName: String,
    groupColor: UIColor
  ) -> PostGroup.ToDoGroup
}
