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
  var payload: PostGroupScenePayloadable? { get set }
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
  var payload: PostGroupScenePayloadable? {
    didSet {
      self.setCurrentGroup()
    }
  }
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
    self.presenter?.presentTouchedDoneButton(response: response)
  }
  
  func changeColor(request: PostGroup.ChangeColor.Request) {
    self.currentGroup?.groupColor = request.groupColor
    let response = PostGroup.ChangeColor.Response(groupColor: request.groupColor)
    self.presenter?.presentChangedColor(response: response)
  }
  
  func loadGroupData() {
    let isDoneBottomButtonEnable: Bool = self.isDoneBottomButtonEnable(
      groupName: self.payload?.groupName,
      groupColor: self.payload?.groupColor
    )
    
    let response = PostGroup.LoadGroupData.Response(
      groupName: self.payload?.groupName ?? "",
      groupColor: self.payload?.groupColor,
      isDoneBottomButtonEnable: isDoneBottomButtonEnable
    )
    self.presenter?.presentLoadGroupData(response: response)
  }
}

extension PostGroupInteractor {
  private func setCurrentGroup() {
    guard let payload = self.payload else {
      self.currentGroup = PostGroup.ToDoGroup(
        groupID: nil,
        groupName: nil,
        groupColor: nil
      )
      return
    }
    
    self.currentGroup = PostGroup.ToDoGroup(
      groupID: payload.groupID,
      groupName: payload.groupName,
      groupColor: payload.groupColor
    )
  }
  
  private func isDoneBottomButtonEnable(groupName: String?, groupColor: UIColor?) -> Bool {
    var isButtonEnable: Bool
    if (groupName == nil) || (groupColor == nil) {
      isButtonEnable = false
    } else {
      isButtonEnable = true
    }
    return isButtonEnable
  }
}
