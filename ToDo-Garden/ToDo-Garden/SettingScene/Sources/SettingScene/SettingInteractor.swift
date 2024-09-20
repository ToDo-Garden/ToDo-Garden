//
//  SettingInteractor.swift
//  
//
//  Created by Wood on 8/5/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SettingSceneAPI
import SettingSceneEntity

protocol SettingDataStore {
  // var name: String { get set }
}

protocol SettingBusinessLogic {
  func fetchAppVersion()
}

class SettingInteractor: SettingDataStore {
  // var name: String = ""
  private var fetchAppVersionTask: Task<Void, Never>?

  var presenter: SettingPresentationLogic?
  private let settingWorker: SettingWorkable

  // MARK: Dependency
  private let appServiceWorker: ApplicationServiceWorker

  init(settingWorker: SettingWorkable, appServiceWorker: ApplicationServiceWorker) {
    self.settingWorker = settingWorker
    self.appServiceWorker = appServiceWorker
  }
}

// MARK: - Request to worker

extension SettingInteractor: SettingBusinessLogic {
  func fetchAppVersion() {
    self.fetchAppVersionTask = Task {
      let currentAppVersion = self.appServiceWorker.fetchAppVersion()
      let latestVersion = await self.settingWorker.requestLatestAppVersion()
      let isLatestVersion = latestVersion == currentAppVersion
      let response = Setting.FetchAppVersion.Response(
        currentAppVersion: currentAppVersion,
        isLatestVersion: isLatestVersion
      )
      await self.presenter?.presentAppVersion(response: response)
    }
  }
}
