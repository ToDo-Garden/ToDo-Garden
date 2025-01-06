//
//  SearchGardenPresenter.swift
//
//
//  Created by SONG on 11/18/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SearchGardenSceneEntity

@MainActor
protocol SearchGardenPresentationLogic {
  func presentUserDataForAddingGarden(response: SearchGarden.LoadFriendGarden.Response)
  func presentResultOfAddingGarden()
  func presentGardenForSearchingGarden(response: SearchGarden.LoadSearchedGarden.Response)
  func presentErrorInfoToast(error: Error)
}

final class SearchGardenPresenter {
  weak var viewController: SearchGardenDisplayLogic?
}

// MARK: - Request to ViewController

extension SearchGardenPresenter: SearchGardenPresentationLogic {
  func presentUserDataForAddingGarden(response: SearchGarden.LoadFriendGarden.Response) {
    let viewModel = SearchGarden.LoadFriendGarden.ViewModel(
      userImage: response.userImage,
      userNickname: response.fetchedData.data.nickname,
      userIntroduction: response.fetchedData.data.introduction,
      userGarden: response.fetchedData.data.pomodoroRecords,
      isButtonEnable: !response.fetchedData.isFriend
    )
    
    self.viewController?.displayFriendGarden(viewModel: viewModel)
  }
  
  func presentResultOfAddingGarden() {
    self.viewController?.displayAddGarden()
  }
  
  func presentGardenForSearchingGarden(response: SearchGarden.LoadSearchedGarden.Response) {
    let viewModel = SearchGarden.LoadSearchedGarden.ViewModel(
      fetchedData: response.fetchedData
    )
    
    self.viewController?.displaySearchedGarden(viewModel: viewModel)
  }
  
  func presentErrorInfoToast(error: any Error) {
    self.viewController?.displayErrorInfoToast(error: error)
  }
}
