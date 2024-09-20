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
  func presentAppVersion(response: Setting.FetchAppVersion.Response)
}

class SettingPresenter {
	weak var viewController: SettingDisplayLogic?
}

// MARK: - Request to ViewController

extension SettingPresenter: SettingPresentationLogic {
  func presentAppVersion(response: Setting.FetchAppVersion.Response) {}
}
