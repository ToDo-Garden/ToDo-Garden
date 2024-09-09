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
  func doSomething(request: UserInfoScene.Something.Request)
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
      let photoForEdit = try await self.userPhotoWorker.requestPhoto()
      // TODO: 서버에 프로필 이미지 변경 요청
    }
  }

  func openSettingApp() {
    self.appServiceWorker.openSettingApp()
  }

  func doSomething(request: UserInfoScene.Something.Request) {
    self.userInfoWorker.doSomeWork()

    let response = UserInfoScene.Something.Response()
    self.presenter?.presentSomething(response: response)
  }
}
