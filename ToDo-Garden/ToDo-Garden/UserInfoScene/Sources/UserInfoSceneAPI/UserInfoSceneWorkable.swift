//
//  UserInfoSceneWorkable.swift
//  
//
//  Created by Wood on 8/28/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

public protocol UserInfoSceneWorkable {
  func requestChangeProfileImage(with data: Data) throws
  func requestUserProfile(urlString: String) async -> String
  func requestWithdraw() async throws
}
