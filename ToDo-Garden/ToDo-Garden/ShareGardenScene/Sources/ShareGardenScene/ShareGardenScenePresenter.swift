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
  func presentFriendsGardens(response: ShareGardenScene.RequestFriendsGardenList.Response)
  func stopShimmeringFriendsGardenList()
}

final class ShareGardenScenePresenter {
  weak var viewController: ShareGardenSceneDisplayLogic?
}

// MARK: - Request to ViewController

extension ShareGardenScenePresenter: ShareGardenScenePresentationLogic {
  func presentMyGarden(response: ShareGardenScene.RequestMyGarden.Response) {
    // TODO: - viewcontroller 연결
  }
  
  func presentFriendsGardens(response: ShareGardenScene.RequestFriendsGardenList.Response) {
    let identifiers = response.friendsGardenList.map(\.id)
    
    self.viewController?.displayFriendsGardenList(
      ShareGardenScene.RequestFriendsGardenList.ViewModel(identifiers: identifiers)
    )
  }
  
  func stopShimmeringFriendsGardenList() {
    self.viewController?.stopShimmeringFriendsGardenList()
  }
}
