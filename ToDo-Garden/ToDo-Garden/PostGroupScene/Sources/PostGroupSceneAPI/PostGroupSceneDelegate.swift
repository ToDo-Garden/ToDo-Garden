//
//  PostGroupSceneDelegate.swift
//
//
//  Created by SONG on 9/12/24.
//

import Foundation
import PostGroupSceneEntity

public protocol PostGroupSceneDelegate: AnyObject {
  func addGroup(group: PostGroup.ToDoGroup)
  func editGroup(group: PostGroup.ToDoGroup)
}
