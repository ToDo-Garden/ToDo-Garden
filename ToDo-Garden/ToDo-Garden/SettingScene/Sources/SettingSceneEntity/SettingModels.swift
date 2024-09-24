//
//  SettingModels.swift
//  
//
//  Created by Wood on 8/5/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

public enum Setting {
  
  // MARK: Use cases

  public enum FetchUserNickName {
    public struct Response {
      public let nickName: String

      public init(nickName: String) {
        self.nickName = nickName
      }
    }

    public struct ViewModel {
      public let nickName: String

      public init(nickName: String) {
        self.nickName = nickName
      }
    }
  }

  public enum FetchUserProfileImage {
    public struct Response {
      public let imageData: Data

      public init(imageData: Data) {
        self.imageData = imageData
      }
    }

    public struct ViewModel {
      public let imageData: Data

      public init(imageData: Data) {
        self.imageData = imageData
      }
    }
  }

  public enum FetchAppVersion {
    public struct Request {
      public init() { }
    }

    public struct Response {
      public let versionNumber: String?
      public let appVersionStatus: AppVersionStatus

      public init(versionNumber: String?, appVersionStatus: AppVersionStatus) {
        self.versionNumber = versionNumber
        self.appVersionStatus = appVersionStatus
      }
    }

    public struct ViewModel {
      public let versionNumber: String
      public let appVersionStatus: AppVersionStatus

      public init(versionNumber: String, appVersionStatus: AppVersionStatus) {
        self.versionNumber = versionNumber
        self.appVersionStatus = appVersionStatus
      }
    }
  }
}

public extension Setting {
  enum AppVersionStatus {
    case outdated
    case latest
  }
}
