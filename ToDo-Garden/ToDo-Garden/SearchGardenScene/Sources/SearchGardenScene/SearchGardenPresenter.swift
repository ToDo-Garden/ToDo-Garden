//
//  SearchGardenPresenter.swift
//
//
//  Created by SONG on 11/18/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SearchGardenSceneEntity
import ToDoGardenUIComponent

@MainActor
protocol SearchGardenPresentationLogic {
  func presentLoadFriendGarden(response: SearchGarden.LoadFriendGarden.Response)
  func presentAddGarden()
  func presentSearchedGarden(response: SearchGarden.LoadSearchedGarden.Response)
  func presentErrorInfoToast(error: Error)
}

final class SearchGardenPresenter {
  weak var viewController: SearchGardenDisplayLogic?
}

// MARK: - Request to ViewController

extension SearchGardenPresenter: SearchGardenPresentationLogic {
  func presentLoadFriendGarden(response: SearchGarden.LoadFriendGarden.Response) {
    let viewModel = SearchGarden.LoadFriendGarden.ViewModel(
      userImage: response.userImage,
      userNickname: response.fetchedData.data.nickname,
      userIntroduction: response.fetchedData.data.introduction,
      userGarden: self.convertToPomodoroRecord(
        from: response.fetchedData.data.pomodoroRecords
      ),
      isButtonEnable: !response.fetchedData.isFriend
    )
    
    self.viewController?.displayFriendGarden(viewModel: viewModel)
  }
  
  func presentAddGarden() {
    self.viewController?.displayAddGarden()
  }
  
  func presentSearchedGarden(response: SearchGarden.LoadSearchedGarden.Response) {
    let viewModel = SearchGarden.LoadSearchedGarden.ViewModel(
      fetchedData: response.fetchedData
    )
    
    self.viewController?.displaySearchedGarden(viewModel: viewModel)
  }
  
  func presentErrorInfoToast(error: any Error) {
    self.viewController?.displayErrorInfoToast(error: error)
  }
}

extension SearchGardenPresenter {
  private func convertToPomodoroRecord(from dtos: [SearchGarden.UserGarden]) -> [PomodoroRecord] {
    var records: [PomodoroRecord] = []
    for dto in dtos {
      records.append(PomodoroRecord(date: dto.date.toDateISO8601Format(), pomodoroCount: dto.pomodoroCount))
    }
    return records
  }
}
