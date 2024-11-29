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
    public struct Request {
      public let userID: String
      public let userImage: UIImage?
      
      public init(userID: String, userImage: UIImage?) {
        self.userID = userID
        self.userImage = userImage
      }
    }
    public struct Response {
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
    public struct ViewModel {
      public let userImage: UIImage?
      public let userNickname: String
      public let userIntroduction: String
      public let userGarden: PomodoroRecordCollection
      public let isButtonEnable: Bool
      
      public init(
        userImage: UIImage?,
        userNickname: String,
        userIntroduction: String,
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
    public struct Request {
      public init() { }
    }
    public struct Response {
      public init() { }
    }
    public struct ViewModel {
      public init() { }
    }
  }
  
  public enum SearchGarden {
    public struct Request {
      public init() { }
    }
    public struct Response {
      public init() { }
    }
    public struct ViewModel {
      public init() { }
    }
  }
}

extension SearchGarden {
  public struct FetchedUserDataForAddingGarden: Sendable {
    public let userNickname: String
    public let userIntroduction: String
    public let userGarden: PomodoroRecordCollection
    public let isFriend: Bool
    
    public init(
      userNickname: String,
      userIntroduction: String,
      userGarden: PomodoroRecordCollection,
      isFriend: Bool
    ) {
      self.userNickname = userNickname
      self.userIntroduction = userIntroduction
      self.userGarden = userGarden
      self.isFriend = isFriend
    }
  }
}

extension SearchGarden {
  public struct CurrentSelectedUser {
    public let userID: String
    
    public init(userID: String) {
      self.userID = userID
    }
  }
}
