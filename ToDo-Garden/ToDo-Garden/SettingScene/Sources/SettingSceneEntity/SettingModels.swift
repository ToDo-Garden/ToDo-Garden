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
    public struct Request {
      public init() { }
    }

    public struct Response {
      public let currentAppVersion: String?
      public let isLatestVersion: Bool

      public init(currentAppVersion: String?, isLatestVersion: Bool) {
        self.currentAppVersion = currentAppVersion
        self.isLatestVersion = isLatestVersion
      }
    }

    public struct ViewModel {
      public init() { }
    }
  }
}
