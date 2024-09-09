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
}

protocol PostGroupBusinessLogic {
  func loadGroupData()
  func changeColor(request: PostGroup.ChangeColor.Request)
  func touchDoneButton(request: PostGroup.TouchDoneButton.Request)
}

class PostGroupInteractor: PostGroupDataStore {
  var presenter: PostGroupPresentationLogic?
  private let postGroupWorker: PostGroupWorkable
  var payload: PostGroupScenePayloadable?
  
  init(postGroupWorker: PostGroupWorkable) {
    self.postGroupWorker = postGroupWorker
  }
}

// MARK: - Request to worker

extension PostGroupInteractor: PostGroupBusinessLogic {
  func touchDoneButton(request: PostGroupSceneEntity.PostGroup.TouchDoneButton.Request) {
    guard let groupID = payload?.groupID else {
      return
    }
    
    self.postGroupWorker.touchDoneButton(
      groupID: groupID,
      groupName: request.groupName,
      groupColor: request.groupColor
    )
    
    let response = PostGroup.TouchDoneButton.Response(
      groupID: groupID,
      groupName: request.groupName,
      groupColor: request.groupColor
    )
    
    self.presenter?.presentTouchedDoneButton(response: response)
  }
  
  func changeColor(request: PostGroup.ChangeColor.Request) {
    self.postGroupWorker.changeColor(groupColor: request.groupColor)
    // 성공했다고 가정
    let response = PostGroup.ChangeColor.Response(groupID: "ID", groupColor: request.groupColor)
    self.presenter?.presentChangedColor(response: response)
  }
  
  func loadGroupData() {
    let isDoneBottomButtonEnable: Bool = self.isDoneBottomButtonEnable(
      groupName: payload?.groupName,
      groupColor: payload?.groupColor
    )
    let response = PostGroup.LoadGroupData.Response(
      groupName: payload?.groupName ?? "",
      groupColor: payload?.groupColor,
      isDoneBottomButtonEnable: isDoneBottomButtonEnable
    )
    self.presenter?.presentLoadGroupData(response: response)
  }
}

extension PostGroupInteractor {
  
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
