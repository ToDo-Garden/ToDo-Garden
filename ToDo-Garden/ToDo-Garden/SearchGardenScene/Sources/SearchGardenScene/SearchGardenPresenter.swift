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
  func presentUserDataForAddingGarden(response: SearchGarden.LoadUserDataForAddingGarden.Response)
  func presentResultOfAddingGarden(response: SearchGarden.AddGarden.Response)
  func presentGardenForSearchingGarden(response: SearchGarden.LoadSearchedGarden.Response)
}

final class SearchGardenPresenter {
  weak var viewController: SearchGardenDisplayLogic?
}

// MARK: - Request to ViewController

extension SearchGardenPresenter: SearchGardenPresentationLogic {
  func presentUserDataForAddingGarden(response: SearchGarden.LoadUserDataForAddingGarden.Response) {
    let viewModel = SearchGarden.LoadUserDataForAddingGarden.ViewModel(
      userImage: response.userImage,
      userNickname: response.fetchedData.userNickname,
      userIntroduction: response.fetchedData.userIntroduction,
      userGarden: response.fetchedData.userGarden,
      isButtonEnable: !response.fetchedData.isFriend
    )
    
    self.viewController?.displayUserDataForAddingGarden(viewModel: viewModel)
  }
  
  func presentResultOfAddingGarden(response: SearchGarden.AddGarden.Response) {
    let viewModel = SearchGarden.AddGarden.ViewModel(
      isSuccess: response.result.isSuccess
    )
    
    self.viewController?.displayResultOfAddingGarden(viewModel: viewModel)
  }
  
  func presentGardenForSearchingGarden(response: SearchGarden.LoadSearchedGarden.Response) {
    let viewModel = SearchGarden.LoadSearchedGarden.ViewModel(
      fetchedData: response.fetchedData
    )
    
    self.viewController?.displayGardenForSearchingGarden(viewModel: viewModel)
  }
}
