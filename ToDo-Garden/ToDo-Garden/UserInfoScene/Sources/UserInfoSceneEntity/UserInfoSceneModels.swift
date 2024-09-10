//
//  UserInfoSceneModels.swift
//
//
//  Created by Wood on 8/28/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit.UIImage

public enum UserInfoScene {

  // MARK: Use cases

  public enum FetchUserPhotoAccess {
    public struct Response {
      public let isPhotoAccessible: Bool

      public init(isPhotoAccessible: Bool) {
        self.isPhotoAccessible = isPhotoAccessible
      }
    }

    public struct ViewModel {
      public let isPhotoAccessible: Bool

      public init(isPhotoAccessible: Bool) {
        self.isPhotoAccessible = isPhotoAccessible
      }
    }
  }

  public enum ChangeProfileImage {
    public struct Response {
      public let changeResult: Result<UIImage, Error>

      public init(changeResult: Result<UIImage, Error>) {
        self.changeResult = changeResult
      }
    }

    public struct ViewModel {
      public let changeResult: Result<UIImage, Error>

      public init(changeResult: Result<UIImage, Error>) {
        self.changeResult = changeResult
      }
    }
  }
}
