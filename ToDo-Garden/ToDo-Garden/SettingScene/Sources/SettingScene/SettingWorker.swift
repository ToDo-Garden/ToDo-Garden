//
//  SettingWorker.swift
//  
//
//  Created by Wood on 8/5/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SettingSceneAPI

struct SettingWorker: SettingWorkable {
  func requestUserNickName() async -> String {
    return MockData.nickName
  }

  func requestUserProfileImage() async -> Data {
    return MockData.imageData
  }
}

extension SettingWorker {
  private enum MockData {
    static let nickName = "울버린"
    static let imageData = Data()
  }
}
