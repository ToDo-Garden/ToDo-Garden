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
    // HTTPCliendError 를 던질예정
  }
  
  public func requestToAddGarden(userID: String) async throws -> SearchGarden.ResultForAddingGarden {
    return SearchGarden.ResultForAddingGarden(isSuccess: true)
    // HTTPCliendError 를 던질예정 
  }
}
