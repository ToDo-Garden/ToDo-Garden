//
//  EditUserNameSceneModels.swift
//
//
//  Created by Wood on 9/23/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

public enum EditUserNameScene {

  // MARK: Use cases

  public enum Something {
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

extension EditUserNameScene {
  public enum ChangeNickname {
    public struct RequestDTO: Sendable, Codable {
      public let nickname: String
      public init(nickname: String) {
        self.nickname = nickname
      }
      
      enum CodingKeys: String, CodingKey {
        case nickname = "new_nickname"
      }
    }
  }
}
