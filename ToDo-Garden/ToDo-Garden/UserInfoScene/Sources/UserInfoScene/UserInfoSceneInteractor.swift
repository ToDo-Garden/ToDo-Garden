//
//  UserInfoSceneInteractor.swift
//
//
//  Created by Wood on 8/28/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import UserInfoSceneAPI
import UserInfoSceneEntity

protocol UserInfoSceneDataStore {
  // var name: String { get set }
}

protocol UserInfoSceneBusinessLogic {
  func fetchUserPhotoToChange()
  func moveToSettingApp()
  func doSomething(request: UserInfoScene.Something.Request)
}

class UserInfoSceneInteractor: UserInfoSceneDataStore {
  private var profileImageLoadTask: Task<Void, Error>?

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
  func fetchUserPhotoToChange() {
    self.profileImageLoadTask = Task {
      let isPhotoAccessEnabled = await self.userPhotoWorker.fetchPhotoAcess()
      if isPhotoAccessEnabled {
        let selectedImage = try await self.userPhotoWorker.requestImage()
        print(selectedImage)
      } else {
        await MainActor.run {
          self.presenter?.presentSettingAppAlsert()
        }
      }
    }
  }

  func moveToSettingApp() {
    let isSettingAppOpened = self.appServiceWorker.openSettingApp()
    print(isSettingAppOpened)
  }

  func doSomething(request: UserInfoScene.Something.Request) {
    self.userInfoWorker.doSomeWork()

    let response = UserInfoScene.Something.Response()
    self.presenter?.presentSomething(response: response)
  }
}
