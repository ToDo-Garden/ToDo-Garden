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
  
  public enum LoadFriendGarden {
    public struct Request: Sendable {
      public let userID: UUID
      public let userImage: UIImage?
      
      public init(userID: UUID, userImage: UIImage?) {
        self.userID = userID
        self.userImage = userImage
      }
    }
    public struct Response: Sendable {
      public let userID: UUID
      public let userImage: UIImage?
      public let fetchedData: LoadFriendGardenDTO.Response
      
      public init(
        userID: UUID,
        userImage: UIImage?,
        fetchedData: LoadFriendGardenDTO.Response
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
      public let userGarden: [UserGarden]
      public let isButtonEnable: Bool
      
      public init(
        userImage: UIImage?,
        userNickname: String,
        userIntroduction: String?,
        userGarden: [UserGarden],
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
  
  public enum LoadSearchedGarden {
    public struct Request: Sendable {
      public let inputText: String
      public init(inputText: String) {
        self.inputText = inputText
      }
    }
    public struct Response: Sendable {
      public let fetchedData: SearchedGardenList
      public init(fetchedData: SearchedGardenList) {
        self.fetchedData = fetchedData
      }
    }
    public struct ViewModel: Sendable {
      public let fetchedData: SearchedGardenList
      public init(fetchedData: SearchedGardenList) {
        self.fetchedData = fetchedData
      }
    }
  }
}

extension SearchGarden {
  public enum LoadFriendGardenDTO {
    public struct Response: Sendable, Codable {
      public let data: FriendGardenInfo
      public let isFriend: Bool
    }
    
    public struct FriendGardenInfo: Sendable, Codable {
      public let nickname: String
      public let introduction: String?
      public let pomodoroRecords: [UserGarden]
      
      public init(
        nickname: String,
        introduction: String?,
        pomodororecords: [UserGarden]
      ) {
        self.nickname = nickname
        self.introduction = introduction
        self.pomodoroRecords = pomodororecords
      }
    }
  }
  
  public struct UserGarden: Sendable, Codable {
    public let date: String
    public let pomodoroCount: Int
    
    public init(date: String, pomodoroCount: Int) {
      self.date = date
      self.pomodoroCount = pomodoroCount
    }
  }
}

extension SearchGarden {
  public enum AddGardenDTO {
    public struct Response: Sendable, Codable {
      public let gardenId: String
      
      public init(gardenId: String) {
        self.gardenId = gardenId
      }
      enum CodingKeys: String, CodingKey {
        case gardenId = "garden_id"
      }
    }
  }
  
  public enum SearchGardenUsersDTO {
    public struct Response: Sendable, Decodable {
      public let data: [User]?
      public let isEndPage: Bool
      public init(data: [User], isEndPage: Bool) {
        self.data = data
        self.isEndPage = isEndPage
      }
      
      public struct User: Sendable, Decodable {
        public let id: String
        public let imageurl: String?
        public let nickname: String
        public let customId: String
      }
    }
  }
}

extension SearchGarden {
  public struct CurrentSelectedUser: Sendable {
    public let userID: UUID
    
    public init(userID: UUID) {
      self.userID = userID
    }
  }
  
  public struct SearchedGardenList: Sendable {
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
