//
//  SearchGardenWorkerStub.swift
//  SearchGardenScene
//
//  Created by SONG on 2/10/25.
//

// swiftlint:disable all
import Foundation

import SearchGardenSceneAPI
import SearchGardenSceneEntity

class SearchGardenWorkerStub {
  private var isFriend: Bool?
  private var error: Error?
  
  func setLoadFriendGardenData(isFriend: Bool) {
    self.isFriend = isFriend
  }
  
  func setError(_ error: Error) {
    self.error = error
  }
  
  func reset() {
    self.error = nil
    self.isFriend = nil
  }
}

extension SearchGardenWorkerStub: SearchGardenWorkable {
  func loadFriendGarden(userID: UUID) async throws -> SearchGardenSceneEntity.SearchGarden.LoadFriendGardenDTO.Response {
    if let error = self.error {
      throw error
    }
    
    let userDetail = AllUsersMock.getUserDetails(by: userID)
    
    let response = SearchGarden.LoadFriendGardenDTO.Response(
      data: SearchGarden.LoadFriendGardenDTO.FriendGardenInfo.init(
        nickname: userDetail!.nickname,
        introduction: userDetail?.customId,
        pomodororecords: []
      ),
      isFriend: self.isFriend!
    )
    
    return response
  }
  
  func addGarden(userID: UUID) async throws {
    if let error = self.error {
      throw error
    }
  }
  
  func loadSearchedGardenList(inputText: String, page: Int) async throws -> SearchGardenSceneEntity.SearchGarden.SearchedGardenList {
    if let error = self.error {
      throw error
    }
    
    return .init(
      searchedGardens: AllUsersMock.filterUsers(by: inputText),
      page: page,
      isEndPage: true
    )
  }
}
// swiftlint:enable all
