//
//  PostGroupPresenter.swift
//
//
//  Created by SONG on 7/8/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import PostGroupSceneEntity

protocol PostGroupPresentationLogic {
  func presentChangedColor(response: PostGroup.ChangeColor.Response)
  func presentLoadGroupData(response: PostGroup.LoadGroupData.Response)
  func presentTouchedDoneButton(response: PostGroup.TouchDoneButton.Response)
}

class PostGroupPresenter {
  weak var viewController: PostGroupDisplayLogic?
}

// MARK: - Request to ViewController

extension PostGroupPresenter: PostGroupPresentationLogic {
  func presentChangedColor(response: PostGroup.ChangeColor.Response) {
    let viewModel = PostGroup.ChangeColor.ViewModel(groupColor: response.groupColor)
    self.viewController?.displayChangedColor(viewModel: viewModel)
  }
  
  func presentLoadGroupData(response: PostGroup.LoadGroupData.Response) {
    var sceneTitle: String
    let isEditGroupMode = response.isDoneBottomButtonEnable
    if isEditGroupMode {
      sceneTitle = Constant.StringLiteral.titleEditGroup
    } else {
      sceneTitle = Constant.StringLiteral.titleAddGroup
    }
    
    let viewModel = PostGroup.LoadGroupData.ViewModel(
      sceneTitle: sceneTitle,
      groupName: response.groupName,
      groupColor: response.groupColor,
      isDoneBottomButtonEnable: response.isDoneBottomButtonEnable
    )
    self.viewController?.displayPayload(viewModel: viewModel)
  }
  
  func presentTouchedDoneButton(response: PostGroup.TouchDoneButton.Response) {
    let viewModel = PostGroup.TouchDoneButton.ViewModel()
    self.viewController?.displayTouchedDondButton(viewModel: viewModel)
  }
}
