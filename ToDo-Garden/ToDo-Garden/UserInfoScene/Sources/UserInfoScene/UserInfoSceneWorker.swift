//
//  UserInfoSceneWorker.swift
//  
//
//  Created by Wood on 8/28/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import UserInfoSceneAPI
import UserInfoSceneEntity

public struct UserInfoSceneWorker: UserInfoSceneWorkable {
  public init() {}

  public func requestChangeProfileImage(with data: Data) throws {
    return
  }

  public func requestUserProfile(urlString: String) async -> String {
    let data = UserInfoScene.UserInfo.self
    if urlString == data.nickName.rawValue {
      try? await Task.sleep(nanoseconds: 1_000_000_000)
      return MockData.nickName
    } else if urlString == data.introduction.rawValue {
      try? await Task.sleep(nanoseconds: 1_000_000_000)
      return MockData.introduction
    } else if urlString == data.id.rawValue {
      try? await Task.sleep(nanoseconds: 2_000_000_000)
      return MockData.id
    } else {
      try? await Task.sleep(nanoseconds: 3_000_000_000)
      return MockData.email
    }
  }

  public func requestWithdraw() async throws {}

  public func requestSignOut() async throws {}
}

extension UserInfoSceneWorker {
  private enum MockData {
    static let nickName = "울버린"
    static let introduction = "나는 나뭇잎 마을의"
    static let id = "@noah0316"
    static let email = "dev.noah0316@gmail.com"
  }
}
