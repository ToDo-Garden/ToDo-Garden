//
//  SearchGardenWorker.swift
//  
//
//  Created by SONG on 11/18/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SearchGardenSceneAPI
import SearchGardenSceneEntity
import ToDoGardenUIComponent // TODO: 제거 예정

public struct SearchGardenWorker: SearchGardenWorkable {
  
  public init() {
  }
  
  public func fetchUserDataForAddingGarden(userID: String) async -> SearchGarden.FetchedUserDataForAddingGarden {
    return SearchGarden.FetchedUserDataForAddingGarden(
      userNickname: "UserNickname",
      userIntroduction: "UserIntroduction",
      userGarden: PomodoroRecordCollection(),
      isFriend: false
    )
  }
  
}
