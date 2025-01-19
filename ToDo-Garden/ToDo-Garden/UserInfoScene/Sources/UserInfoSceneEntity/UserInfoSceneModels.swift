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

  public enum ConfigureCollectionView {
    public struct ViewModel {
      public let userInfoSections: [UserInfoSection]

      public init(userInfoSections: [UserInfoSection]) {
        self.userInfoSections = userInfoSections
      }
    }
  }

  public enum FetchProfile {
    public struct Response {
      public let description: String
      public let item: UserInfoItem

      public init(description: String, item: UserInfoItem) {
        self.description = description
        self.item = item
      }
    }

    public struct ViewModel {
      public let description: String
      public let item: UserInfoItem

      public init(description: String, item: UserInfoItem) {
        self.description = description
        self.item = item
      }
    }
  }

  public enum WithdrawMembership {
    public struct Response {
      public let withdrawError: Error?

      public init(withdrawError: Error?) {
        self.withdrawError = withdrawError
      }
    }

    public struct ViewModel {
      public let withdrawError: Error?

      public init(withdrawError: Error?) {
        self.withdrawError = withdrawError
      }
    }
  }

  public enum SignOut {
    public struct Response {
      public let signOutError: Error?

      public init(signOutError: Error?) {
        self.signOutError = signOutError
      }
    }

    public struct ViewModel {
      public let signOutError: Error?

      public init(signOutError: Error?) {
        self.signOutError = signOutError
      }
    }
  }
  
  public enum FetchProfileImage {
    public struct Response {
      public let image: UIImage?

      public init(image: UIImage?) {
        self.image = image
      }
    }

    public struct ViewModel {
      public let image: UIImage

      public init(image: UIImage) {
        self.image = image
      }

    }

  }
}

// MARK: - Data Objects

public extension UserInfoScene {
  enum UserInfo: String {
    case nickName
    case introduction
    case id
    case email
  }
}

// MARK: - Configure CollectionView

public extension UserInfoScene {
  struct UserInfoSection: Hashable {
    public let title: String
    public let items: [UserInfoItem]

    public init(title: String, items: [UserInfoItem]) {
      self.title = title
      self.items = items
    }
  }

  struct UserInfoItem: Hashable {
    public let userInfo: UserInfo
    public let title: String
    public let isRightImageExisted: Bool

    public init(userInfo: UserInfo, title: String, isRightImageExisted: Bool) {
      self.userInfo = userInfo
      self.title = title
      self.isRightImageExisted = isRightImageExisted
    }
  }
}

extension UserInfoScene {
  public struct GetProfileResponseDTO: Decodable {
    public let id: String
    public let customId: String
    public let introduction: String
    public let nickname: String
    public let email: String
    
    private enum CodingKeys: String, CodingKey {
      case id
      case customId = "custom_id"
      case introduction
      case nickname
      case email
    }
  }
}
