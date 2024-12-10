//
//  SearchGardenWorker.swift
//
//
//  Created by SONG on 11/18/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import HTTPClientAPI
import SearchGardenSceneAPI
import SearchGardenSceneEntity
import ToDoGardenUIComponent // TODO: 제거 예정

public struct SearchGardenWorker: SearchGardenWorkable {
  
  public init() {
  }
  
  public func fetchUserDataForAddingGarden(userID: String) async throws -> SearchGarden.FetchedUserDataForAddingGarden {
    
    return SearchGarden.FetchedUserDataForAddingGarden(
      userNickname: "UserNickname",
      userIntroduction: "UserIntroduction",
      userGarden: PomodoroRecordCollection(),
      isFriend: false
    )
    // HTTPClientError 를 던질예정
  }
  
  public func requestToAddGarden(userID: String) async throws -> SearchGarden.ResultForAddingGarden {
    return SearchGarden.ResultForAddingGarden(isSuccess: true)
    // HTTPClientError 를 던질예정
  }
  public func fetchSearchedGardenData(
    inputText: String,
    page: Int
  ) async throws -> SearchGarden.FetchedGardenDataForSearching {
    let result = getTextIncludedUser(inputText: inputText)
    return SearchGarden.FetchedGardenDataForSearching(searchedGardens: result, page: 0, isEndPage: true)
    // HTTPClientError 를 던질예정
  }
}

// TODO: ↓ 제거 예정
extension SearchGardenWorker {
  private func getTextIncludedUser(inputText: String) -> [SearchGardenUser] {
    return MockData.preview.filter { user in
      user.userID.contains(inputText)
    }
  }
}
