//
//  UserInfoSceneWorker.swift
//  
//
//  Created by Wood on 8/28/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import UserInfoSceneAPI

public struct UserInfoSceneWorker: UserInfoSceneWorkable {
  public init() {}

  public func requestChangeProfileImage(with data: Data) throws {
    return
  }

  public func requestUserProfile(urlString: String) async -> String {
    return ""
  }
}
