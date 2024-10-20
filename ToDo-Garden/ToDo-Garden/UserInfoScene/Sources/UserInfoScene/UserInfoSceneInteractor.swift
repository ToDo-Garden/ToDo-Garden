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
  var userIntroduction: String? { get set }
}

@MainActor
protocol UserInfoSceneBusinessLogic {
  func configureCollectionView()
  func fetchUserPhotoAccess()
  func changeUserProfileImage()
  func openSettingApp()
  func withdrawMembership()
  func signOut()
  func reloadUserIntroduction(_ introduction: String?)
}

final class UserInfoSceneInteractor: UserInfoSceneDataStore {
  var userIntroduction: String?

  private var requestPhotoAccessTask: Task<Void, Error>?
  private var requestUserPhotoTask: Task<Void, Error>?
  private var requestWithdrawTask: Task<Void, Error>?
  private var requestSignOutTask: Task<Void, Error>?

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
  func configureCollectionView() {
    self.presenter?.presentCollectionViewSections()
  }

  func fetchUserPhotoAccess() {
    self.requestPhotoAccessTask = Task {
      let isPhotoAccessible = await self.userPhotoWorker.requestPhotoAccess()
      let response = UserInfoScene.FetchUserPhotoAccess.Response(isPhotoAccessible: isPhotoAccessible)

      self.presenter?.presentUserPhotoAccess(response: response)
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

          self.presenter?.presentChangedProfileImage(response: response)
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

  func withdrawMembership() {
    self.requestWithdrawTask = Task {
      let withdrawError: Error?
      do {
        try await self.userInfoWorker.requestWithdraw()
        withdrawError = nil
      } catch let error {
        withdrawError = error
      }

      let response = UserInfoScene.WithdrawMembership.Response(withdrawError: withdrawError)
      self.presenter?.presentWithdrawResult(response: response)
    }
  }

  func signOut() {
    self.requestSignOutTask = Task {
      let signOutError: Error?
      do {
        try await self.userInfoWorker.requestSignOut()
        signOutError = nil
      } catch let error {
        signOutError = error
      }

      let response = UserInfoScene.SignOut.Response(signOutError: signOutError)
      self.presenter?.presentSignOutResult(response: response)
    }
  }

  func reloadUserIntroduction(_ introduction: String?) {
    self.userIntroduction = introduction
    if let introduction {
      self.presenter?.presentChangedUserIntroduction(introduction)
    } else {
      self.presenter?.presentEmptyUserIntroduction()
    }
  }
}

extension UserInfoSceneInteractor: UserInfoLoadable {
  func requestDescription(for userInfo: UserInfoScene.UserInfo) async -> String {
    let description = await self.userInfoWorker.requestUserProfile(urlString: userInfo.rawValue)
    if userInfo == .introduction {
      self.userIntroduction = description
    }
    return description
  }
}
