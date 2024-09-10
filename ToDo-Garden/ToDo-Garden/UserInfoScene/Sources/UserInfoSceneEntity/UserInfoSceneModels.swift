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
    public struct Response {
      public let userInfoSections: [UserInfoSection]

      public init(userInfoSections: [UserInfoSection]) {
        self.userInfoSections = userInfoSections
      }
    }

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
}

// MARK: - Data Objects

public extension UserInfoScene {
  struct UserProfile {
    public let nickName: String
    public let introduction: String
    public let id: String
    public let email: String

    public init(nickName: String, introduction: String, id: String, email: String) {
      self.nickName = nickName
      self.introduction = introduction
      self.id = id
      self.email = email
    }
  }
}

// MARK: - Configure CollectionView

public extension UserInfoScene {
  struct UserInfoSection: Hashable {
    public enum Title: String {
      case profileSetting = "프로필 설정"
      case accountSetting = "계정 설정"
    }

    public let title: Title
    public let items: [UserInfoItem]
  }

  struct UserInfoItem: Hashable {
    public enum Title: String {
      case nickName = "닉네임"
      case introduction = "소개"
      case id = "아이디"
      case email = "이메일"
    }

    public enum Position {
      case top
      case middle
      case bottom
    }

    public let title: Title
    public let isRightImageExisted: Bool
    public let position: UserInfoItem.Position
  }

  static let profileSection = UserInfoSection(
    title: UserInfoSection.Title.profileSetting,
    items: [
      UserInfoItem(
        title: UserInfoItem.Title.nickName,
        isRightImageExisted: true,
        position: UserInfoItem.Position.top
      ),
      UserInfoItem(
        title: UserInfoItem.Title.introduction,
        isRightImageExisted: true,
        position: UserInfoItem.Position.bottom
      )
    ]
  )

  static let accountSection = UserInfoSection(
    title: UserInfoSection.Title.accountSetting,
    items: [
      UserInfoItem(
        title: UserInfoItem.Title.id,
        isRightImageExisted: true,
        position: UserInfoItem.Position.top
      ),
      UserInfoItem(
        title: UserInfoItem.Title.email,
        isRightImageExisted: false,
        position: UserInfoItem.Position.bottom
      )
    ]
  )
}
