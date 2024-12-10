//
//  SearchGardenModels.swift
//  
//
//  Created by SONG on 11/18/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import ToDoGardenUIComponent // TODO: PomodoroRecordCollection 이관 예정

public enum SearchGarden {
  
  // MARK: Use cases
  
  public enum LoadUserDataForAddingGarden {
    public struct Request: Sendable {
      public let userID: String
      public let userImage: UIImage?
      
      public init(userID: String, userImage: UIImage?) {
        self.userID = userID
        self.userImage = userImage
      }
    }
    public struct Response: Sendable {
      public let userID: String
      public let userImage: UIImage?
      public let fetchedData: FetchedUserDataForAddingGarden
      
      public init(
        userID: String,
        userImage: UIImage?,
        fetchedData: FetchedUserDataForAddingGarden
      ) {
        self.userID = userID
        self.userImage = userImage
        self.fetchedData = fetchedData
      }
    }
    public struct ViewModel: Sendable {
      public let userImage: UIImage?
      public let userNickname: String
      public let userIntroduction: String?
      public let userGarden: PomodoroRecordCollection
      public let isButtonEnable: Bool
      
      public init(
        userImage: UIImage?,
        userNickname: String,
        userIntroduction: String?,
        userGarden: PomodoroRecordCollection,
        isButtonEnable: Bool
      ) {
        self.userImage = userImage
        self.userNickname = userNickname
        self.userIntroduction = userIntroduction
        self.userGarden = userGarden
        self.isButtonEnable = isButtonEnable
      }
    }
  }
  
  public enum AddGarden {
    public struct Request: Sendable {
      public init() { }
    }
    public struct Response: Sendable {
      public let result: ResultForAddingGarden
      
      public init(result: ResultForAddingGarden) {
        self.result = result
      }
    }
    public struct ViewModel: Sendable {
      public let isSuccess: Bool
      
      public init(isSuccess: Bool) {
        self.isSuccess = isSuccess
      }
    }
  }
  
  public enum LoadSearchedGarden {
    public struct Request: Sendable {
      public let inputText: String
      public let isContinuous: Bool
      public init(inputText: String, isContinuous: Bool) {
        self.inputText = inputText
        self.isContinuous = isContinuous
      }
    }
    public struct Response: Sendable {
      public let fetchedData: FetchedGardenDataForSearching
      public init(fetchedData: FetchedGardenDataForSearching) {
        self.fetchedData = fetchedData
      }
    }
    public struct ViewModel: Sendable {
      public let fetchedData: FetchedGardenDataForSearching
      public init(fetchedData: FetchedGardenDataForSearching) {
        self.fetchedData = fetchedData
      }
    }
  }
}

extension SearchGarden {
  public struct FetchedUserDataForAddingGarden: Sendable {
    public let userNickname: String
    public let userIntroduction: String?
    public let userGarden: PomodoroRecordCollection
    public let isFriend: Bool
    
    public init(
      userNickname: String,
      userIntroduction: String?,
      userGarden: PomodoroRecordCollection,
      isFriend: Bool
    ) {
      self.userNickname = userNickname
      self.userIntroduction = userIntroduction
      self.userGarden = userGarden
      self.isFriend = isFriend
    }
  }
  
  public struct ResultForAddingGarden: Sendable {
    public let isSuccess: Bool
    
    public init(isSuccess: Bool) {
      self.isSuccess = isSuccess
    }
  }
  
  public struct FetchedGardenDataForSearching: Sendable {
    public let searchedGardens: [SearchGardenUser]
    public let page: Int
    public let isEndPage: Bool
    
    public init(searchedGardens: [SearchGardenUser], page: Int, isEndPage: Bool) {
      self.searchedGardens = searchedGardens
      self.page = page
      self.isEndPage = isEndPage
    }
  }
}

extension SearchGarden {
  public struct CurrentSelectedUser: Sendable {
    public let userID: String
    
    public init(userID: String) {
      self.userID = userID
    }
  }
}
