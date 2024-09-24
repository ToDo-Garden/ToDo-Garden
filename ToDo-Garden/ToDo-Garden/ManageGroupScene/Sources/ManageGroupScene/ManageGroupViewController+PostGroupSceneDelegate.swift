//
//  ManageGroupViewController+PostGroupSceneDelegate.swift
//
//
//  Created by SONG on 9/12/24.
//

import UIKit.UIColor

import ManageGroupSceneEntity
import PostGroupSceneAPI
import PostGroupSceneEntity

extension ManageGroupViewController: PostGroupSceneDelegate {
  public func addGroup(group: PostGroup.ToDoGroup) {
    let request = ManageGroup.AddGroup.Request(
      groupID: group.groupID ?? UUID(),
      groupName: group.groupName,
      groupColor: group.groupColor
    )
    
    self.interactor?.addGroup(request: request)
  }
  
  public func editGroup(group: PostGroup.ToDoGroup) {
    guard let groupID = group.groupID else {
      return
    }
    
    let request = ManageGroup.EditGroup.Request(
      groupID: groupID,
      groupName: group.groupName,
      groupColor: group.groupColor
    )
    
    self.interactor?.editGroup(request: request)
  }
}
