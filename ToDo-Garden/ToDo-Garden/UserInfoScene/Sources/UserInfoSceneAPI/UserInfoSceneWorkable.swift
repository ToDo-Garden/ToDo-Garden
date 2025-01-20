//
//  UserInfoSceneWorkable.swift
//  
//
//  Created by Wood on 8/28/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit.UIImage

public protocol UserInfoSceneWorkable {
  func requestChangeProfileImage(with data: Data) async throws
  func requestUserProfile(urlString: String) async throws -> String
  func requestWithdraw() async throws
  func requestSignOut() async throws
  func requestProfileImage() async throws -> UIImage?
}
