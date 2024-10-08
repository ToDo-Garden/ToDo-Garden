//
//  ShareGardenScenePresenter.swift
//
//
//  Created by Noah on 7/4/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import ShareGardenSceneEntity

@MainActor
protocol ShareGardenScenePresentationLogic {
  func presentMyGarden(response: ShareGardenScene.RequestMyGarden.Response)
  func presentMyGardenRequestError()
  func presentFriendsGardens(response: ShareGardenScene.RequestFriendsGardenList.Response)
  func presentFriendsGardenListRequestError()
  func stopShimmeringFriendsGardenList()
}

final class ShareGardenScenePresenter {
  weak var viewController: ShareGardenSceneDisplayLogic?
}

// MARK: - Request to ViewController

extension ShareGardenScenePresenter: ShareGardenScenePresentationLogic {
  func presentMyGarden(response: ShareGardenScene.RequestMyGarden.Response) {
    let viewModel = ShareGardenScene.RequestMyGarden.ViewModel(
      nickname: response.myGarden.nickname,
      description: response.myGarden.description,
      pomodoroRecords: response.myGarden.pomodoroRecords
    )
    
    self.viewController?.displayMyGarden(viewModel)
  }
  
  func presentMyGardenRequestError() {
    self.viewController?.displayMyGardenRequestError()
  }
  
  func presentFriendsGardens(response: ShareGardenScene.RequestFriendsGardenList.Response) {
    let identifiers = response.friendsGardenList.map(\.id)
    
    self.viewController?.displayFriendsGardenList(
      ShareGardenScene.RequestFriendsGardenList.ViewModel(identifiers: identifiers)
    )
  }
  
  func presentFriendsGardenListRequestError() {
    self.viewController?.displayFriendsGardenListRequestError()
  }
  
  func stopShimmeringFriendsGardenList() {
    self.viewController?.stopShimmeringFriendsGardenList()
  }
}
