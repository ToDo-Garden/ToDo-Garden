//
//  SettingPresenter.swift
//
//
//  Created by Wood on 8/5/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SettingSceneEntity

@MainActor
protocol SettingPresentationLogic {
  func presentUserNickName(response: Setting.FetchUserNickName.Response)
  func presentAppVersion(response: Setting.FetchAppVersion.Response)
}

final class SettingPresenter {
  weak var viewController: SettingDisplayLogic?
}

// MARK: - Request to ViewController

extension SettingPresenter: SettingPresentationLogic {
  func presentUserNickName(response: Setting.FetchUserNickName.Response) {}

  func presentAppVersion(response: Setting.FetchAppVersion.Response) {
    let appVersion = self.formatVersionString(response.currentAppVersion)
    let isLatestVersion = response.isLatestVersion
    let viewModel = Setting.FetchAppVersion.ViewModel(
      appVersion: appVersion,
      isLatestVersion: isLatestVersion
    )
    self.viewController?.displayFetchedAppVersion(viewModel: viewModel)
  }
}

// MARK: - Private Functions

extension SettingPresenter {
  private func formatVersionString(_ version: String?) -> String {
    if let version {
      let versionNumbers = version.split(separator: ".")
      let versions = versionNumbers + Array(repeating: "0", count: 3 - versionNumbers.count)
      return "v " + versions.joined(separator: ".") + "."
    } else {
      return "v 0.0.0."
    }
  }
}
