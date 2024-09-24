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
  func fetchUserNickname()
  func fetchUserProfileImage()
  func fetchAppVersion()
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
  func fetchUserNickname() {
    self.fetchUserNicknameTask = Task {
      let nickName = await self.settingWorker.requestUserNickName()
      self.nickName = nickName
      let response = Setting.FetchUserNickName.Response(nickName: nickName)
      await self.presenter?.presentUserNickName(response: response)
    }
  }

  func fetchUserProfileImage() {
    self.fetchUserProfileImageTask = Task {
      let profileImageData = await self.settingWorker.requestUserProfileImage()
      self.profileImageData = profileImageData
      let response = Setting.FetchUserProfileImage.Response(imageData: profileImageData)
      await self.presenter?.presentUserProfileImage(response: response)
    }
  }

  func fetchAppVersion() {
    self.fetchAppVersionTask = Task {
      let versionNumber = self.appServiceWorker.fetchCurrentAppVersion()
      let isUpdateAvailable = await self.appServiceWorker.isUpdateAvailable()
      let appVersionStatus: Setting.AppVersionStatus = isUpdateAvailable ? .outdated : .latest
      let response = Setting.FetchAppVersion.Response(versionNumber: versionNumber, appVersionStatus: appVersionStatus)
      await self.presenter?.presentAppVersion(response: response)
    }
  }

  func openAppStore() {
    self.appServiceWorker.openAppStore()
  }
}
