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
  var nickName: String? { get }
  var profileImageData: Data? { get }
}

protocol SettingBusinessLogic {
  func prepareSettingSceneData()
  func openAppStore()
}

final class SettingInteractor: SettingDataStore {
  var nickName: String?
  var profileImageData: Data?
  
  private var fetchUserNicknameTask: Task<Void, Never>?
  private var fetchUserProfileImageTask: Task<Void, Never>?
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
  func prepareSettingSceneData() {
    self.fetchUserInfo()
    self.fetchAppVersion()
  }

  func openAppStore() {
    self.appServiceWorker.openAppStore()
  }
}

// MARK: - Private Functions

extension SettingInteractor {
  private func fetchUserInfo() {
    self.fetchUserNicknameTask = Task {
      defer { self.fetchUserNicknameTask = nil }

      do {
        try Task.checkCancellation()
        let userInfo = try await self.settingWorker.requestUserInfo()
        try Task.checkCancellation()
        await self.presenter?.presentUserInfo(userInfo.nickname, imageUrl: userInfo.imageUrl)
      } catch let error {
        debugPrint(error.localizedDescription)
      }
    }
  }

  private func fetchAppVersion() {
    self.fetchAppVersionTask = Task {
      do {
        let versionNumber = self.appServiceWorker.currentAppVersion()
        let isUpdateAvailable = try await self.appServiceWorker.isUpdateAvailable()
        let response = Setting.FetchAppVersion.Response(
          versionNumber: versionNumber,
          isLatestVersion: !isUpdateAvailable
        )
        await self.presenter?.presentAppVersion(response: response)
      } catch {
        /// 추가적인 제어가 필요하다면 구현해주세요.
      }
    }
  }
}
