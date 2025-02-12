//
//  SearchGardenDisplayLogicStub.swift
//  SearchGardenScene
//
//  Created by SONG on 2/10/25.
//
// swiftlint:disable all

@testable import SearchGardenScene
import SearchGardenSceneEntity
import ToDoGardenUIComponent

final class SearchGardenDisplayLogicStub: SearchGardenDisplayLogic {
  var currentFriendGarden: SearchGardenSceneEntity.SearchGarden.LoadFriendGarden.ViewModel? = nil
  var isAddingDone: Bool? = nil
  var currentList: [SearchGardenUser]? = nil
  
  func displayFriendGarden(viewModel: SearchGardenSceneEntity.SearchGarden.LoadFriendGarden.ViewModel) {
    self.currentFriendGarden = viewModel
  }
  
  func displayAddGarden() {
    self.isAddingDone = true
  }
  
  func displaySearchedGarden(viewModel: SearchGardenSceneEntity.SearchGarden.LoadSearchedGarden.ViewModel) {
    self.currentList = viewModel.fetchedData.searchedGardens
  }
  
  func displayErrorInfoToast(error: any Error) {
    self.isAddingDone = false
  }
  
  func reset() {
    self.currentList = nil
    self.currentFriendGarden = nil
    self.isAddingDone = nil
  }
}
// swiftlint:enable all
