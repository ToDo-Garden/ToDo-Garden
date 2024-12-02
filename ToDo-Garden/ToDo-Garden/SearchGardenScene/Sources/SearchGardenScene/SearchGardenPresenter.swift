//
//  SearchGardenPresenter.swift
//  
//
//  Created by SONG on 11/18/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SearchGardenSceneEntity

protocol SearchGardenPresentationLogic {
  func presentUserDataForAddingGarden(response: SearchGarden.LoadUserDataForAddingGarden.Response)
  func presentResultOfAddingGarden(response: SearchGarden.AddGarden.Response)
}

class SearchGardenPresenter {
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
    
    Task { @MainActor in
      self.viewController?.displayUserDataForAddingGarden(viewModel: viewModel)
    }
  }
  
  func presentResultOfAddingGarden(response: SearchGarden.AddGarden.Response) {
    let viewModel = SearchGarden.AddGarden.ViewModel(
      isSuccess: response.result.isSuccess
    )
    
    Task { @MainActor in
      self.viewController?.displayResultOfAddingGarden(viewModel: viewModel)
    }
  }
}
