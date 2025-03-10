//
//  SettingModels.swift
//  
//
//  Created by Wood on 8/5/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

public enum Setting {
  
  // MARK: Use cases

  public enum FetchUserInfo {}

  public enum FetchAppVersion {
    public struct Response {
      public let versionNumber: String?
      public let isLatestVersion: Bool

      public init(versionNumber: String?, isLatestVersion: Bool) {
        self.versionNumber = versionNumber
        self.isLatestVersion = isLatestVersion
      }
    }
  }
}

extension Setting.FetchUserInfo {
  public struct RequestDTO: Sendable, Codable {
    public init() {}
  }

  public struct ResponseDTO: Sendable, Codable {
    public let nickname: String
  }
}
