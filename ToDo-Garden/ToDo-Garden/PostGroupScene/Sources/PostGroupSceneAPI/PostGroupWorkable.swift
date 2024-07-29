//
//  PostGroupWorkable.swift
//  
//
//  Created by SONG on 7/8/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit.UIColor

public protocol PostGroupWorkable {
  func changeColor(groupColor: UIColor)
  func touchDoneButton(
    groupID: String,
    groupName: String,
    groupColor: UIColor
  )
}
