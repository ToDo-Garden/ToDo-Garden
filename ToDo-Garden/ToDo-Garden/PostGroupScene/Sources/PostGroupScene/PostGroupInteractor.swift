//
//  PostGroupInteractor.swift
//
//
//  Created by SONG on 7/8/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit.UIColor

import PostGroupSceneAPI
import PostGroupSceneEntity

protocol PostGroupDataStore {
  var currentGroup: PostGroup.ToDoGroup? { get set }
  var delegate: PostGroupSceneDelegate? { get set }
}

protocol PostGroupBusinessLogic {
  func loadGroupData()
  func changeColor(request: PostGroup.ChangeColor.Request)
  func touchDoneButton(request: PostGroup.TouchDoneButton.Request)
}

class PostGroupInteractor: PostGroupDataStore {
  var delegate: PostGroupSceneDelegate?
  var presenter: PostGroupPresentationLogic?
  private let postGroupWorker: PostGroupWorkable
  
  var currentGroup: PostGroup.ToDoGroup?
  
  init(postGroupWorker: PostGroupWorkable) {
    self.postGroupWorker = postGroupWorker
  }
}

// MARK: - Request to worker

extension PostGroupInteractor: PostGroupBusinessLogic {
  func touchDoneButton(request: PostGroupSceneEntity.PostGroup.TouchDoneButton.Request) {
    let groupID: UUID? = self.currentGroup?.groupID
    
    let result = self.postGroupWorker.touchDoneButton(
      groupID: groupID,
      groupName: request.groupName,
      groupColor: request.groupColor
    )
    
    let isAddGroup = result.groupID == nil
    
    if isAddGroup {
      self.delegate?.addGroup(group: result)
    } else {
      self.delegate?.editGroup(group: result)
    }
    
    let response = PostGroup.TouchDoneButton.Response(group: result)
    self.currentGroup = response.group
    self.presenter?.presentAfterTouchingDoneButton(response: response)
  }
  
  func changeColor(request: PostGroup.ChangeColor.Request) {
    self.currentGroup?.groupColor = request.groupColor
    let response = PostGroup.ChangeColor.Response(groupColor: request.groupColor)
    self.presenter?.presentChangedColor(response: response)
  }
  
  func loadGroupData() {
    let isDoneBottomButtonEnable: Bool = self.isDoneBottomButtonEnable(with: self.currentGroup)
    
    let response = PostGroup.LoadGroupData.Response(
      groupName: self.currentGroup?.groupName ?? "",
      groupColor: self.currentGroup?.groupColor,
      isDoneBottomButtonEnable: isDoneBottomButtonEnable
    )
    self.presenter?.presentLoadGroupData(response: response)
  }
}

extension PostGroupInteractor {
  private func isDoneBottomButtonEnable(with currentGroup: PostGroup.ToDoGroup?) -> Bool {
    var isButtonEnable: Bool
    if currentGroup == nil {
      isButtonEnable = false
    } else {
      isButtonEnable = true
    }
    return isButtonEnable
  }
}
