//
//  SettingWorker.swift
//  
//
//  Created by Wood on 8/5/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SettingSceneAPI

struct SettingWorker: SettingWorkable {
  /// 서버로부터 앱의 최신버전을 받아오는 메서드입니다.
  func requestLatestAppVersion() -> String {
    return MockData.latestVersion
  }
}

extension SettingWorker {
  private enum MockData {
    static let latestVersion = "0.1.2"
  }
}
