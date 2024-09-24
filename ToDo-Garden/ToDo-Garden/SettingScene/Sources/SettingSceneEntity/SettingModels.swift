//
//  SettingModels.swift
//  
//
//  Created by Wood on 8/5/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

public enum Setting {
  
  // MARK: Use cases

  public enum FetchAppVersion {
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
