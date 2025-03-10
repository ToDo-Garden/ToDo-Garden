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
    self.fetchUserNickname()
    self.fetchUserProfileImage()
    self.fetchAppVersion()
  }

  func openAppStore() {
    self.appServiceWorker.openAppStore()
  }
}

// MARK: - Private Functions

extension SettingInteractor {
  private func fetchUserNickname() {
    self.fetchUserNicknameTask = Task {
      defer { self.fetchUserNicknameTask = nil }
      
      do {
        try Task.checkCancellation()
        let nickname = try await self.settingWorker.requestUserNickName()
        try Task.checkCancellation()
        await self.presenter?.presentUserNickName(nickname)
      } catch let error {
        debugPrint(error.localizedDescription)
      }
    }
  }

  private func fetchUserProfileImage() {
    self.fetchUserProfileImageTask = Task {
      let profileImageData = await self.settingWorker.requestUserProfileImage()
      self.profileImageData = profileImageData
      await self.presenter?.presentUserProfileImage(profileImageData)
    }
  }

  private func fetchAppVersion() {
    self.fetchAppVersionTask = Task {
      let versionNumber = self.appServiceWorker.fetchCurrentAppVersion()
      let isUpdateAvailable = await self.appServiceWorker.isUpdateAvailable()
      let response = Setting.FetchAppVersion.Response(
        versionNumber: versionNumber,
        isLatestVersion: !isUpdateAvailable
      )
      await self.presenter?.presentAppVersion(response: response)
    }
  }
}
