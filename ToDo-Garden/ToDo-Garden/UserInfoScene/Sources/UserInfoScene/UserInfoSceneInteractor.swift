//
//  UserInfoSceneInteractor.swift
//
//
//  Created by Wood on 8/28/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit.UIImage

import UserInfoSceneAPI
import UserInfoSceneEntity

protocol UserInfoSceneDataStore {
  // var name: String { get set }
}

protocol UserInfoSceneBusinessLogic {
  func fetchUserPhotoAccess()
  func changeUserProfileImage()
  func openSettingApp()
}

class UserInfoSceneInteractor: UserInfoSceneDataStore {
  private var requestPhotoAccessTask: Task<Void, Error>?
  private var requestUserPhotoTask: Task<Void, Error>?

  // var name: String = ""
  var presenter: UserInfoScenePresentationLogic?
  private let userInfoWorker: UserInfoSceneWorkable
  private let appServiceWorker: AppServiceWorkable
  private let userPhotoWorker: UserPhotoWorker

  init(
    userInfoWorker: UserInfoSceneWorkable,
    appServiceWorker: AppServiceWorkable,
    userPhotoWorker: UserPhotoWorker
  ) {
    self.userInfoWorker = userInfoWorker
    self.appServiceWorker = appServiceWorker
    self.userPhotoWorker = userPhotoWorker
  }
}

// MARK: - Request to worker

extension UserInfoSceneInteractor: UserInfoSceneBusinessLogic {
  func fetchUserPhotoAccess() {
    self.requestPhotoAccessTask = Task {
      let isPhotoAccessible = await self.userPhotoWorker.requestPhotoAccess()
      let response = UserInfoScene.FetchUserPhotoAccess.Response(isPhotoAccessible: isPhotoAccessible)

      await MainActor.run {
        self.presenter?.presentUserPhotoAccess(response: response)
      }
    }
  }

  func changeUserProfileImage() {
    self.requestUserPhotoTask = Task {
      do {
        let profileImageToChange = try await self.userPhotoWorker.requestPhoto()
        if let imageData = profileImageToChange.pngData() {
          try self.userInfoWorker.requestChangeProfileImage(with: imageData)
          let response = UserInfoScene.ChangeProfileImage.Response(
            changeResult: Result.success(profileImageToChange)
          )

          await MainActor.run {
            self.presenter?.presentChangedProfileImage(response: response)
          }
        }
      } catch let error {
        let response = UserInfoScene.ChangeProfileImage.Response(
          changeResult: Result.failure(error)
        )
        self.presenter?.presentChangedProfileImage(response: response)
      }
    }
  }

  func openSettingApp() {
    self.appServiceWorker.openSettingApp()
  }
}
