//
//  PostGroupSceneDelegateStub.swift
//  PostGroupScene
//
//  Created by SONG on 2/10/25.
//

// swiftlint:disable all
import Foundation

import PostGroupSceneAPI
import PostGroupSceneEntity

final class PostGroupSceneDelegateStub: PostGroupSceneDelegate {
  var addedGroup: PostGroupSceneEntity.PostGroup.ToDoGroup? = nil
  var editedGroup: PostGroupSceneEntity.PostGroup.ToDoGroup? = nil
  
  func addGroup(group: PostGroupSceneEntity.PostGroup.ToDoGroup) {
    self.addedGroup = group
  }
  
  func editGroup(group: PostGroupSceneEntity.PostGroup.ToDoGroup) {
    self.editedGroup = group
  }
  
  func reset() {
    self.addedGroup = nil
    self.editedGroup = nil
  }
}
// swiftlint:enable all
