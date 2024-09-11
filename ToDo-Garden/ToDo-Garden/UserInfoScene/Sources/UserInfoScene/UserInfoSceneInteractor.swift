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
  func configureCollectionView()
  func fetchUserProfile() async
  func fetchUserPhotoAccess()
  func changeUserProfileImage()
  func openSettingApp()
  func withdrawMembership()
  func signOut()
}

final class UserInfoSceneInteractor: UserInfoSceneDataStore {
  private var userProfile: UserInfoScene.UserProfile?

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

  // TODO: - TaskGroup > async-let
  func fetchUserProfile() async {
    self.userProfile = await withTaskGroup(
      of: (UserInfoScene.UserInfoItem.Title, String).self,
      returning: UserInfoScene.UserProfile.self
    ) { taskGroup in
      for section in [UserInfoScene.profileSection, UserInfoScene.accountSection] {
        for item in section.items {
          taskGroup.addTask {
            await self.callPresenterWhenRequestArrived(for: item)
          }
        }
      }

      return await self.makeUserProfile(with: taskGroup)
    }
  }

  func fetchUserPhotoAccess() {
    self.requestPhotoAccessTask = Task {
      let isPhotoAccessible = await self.userPhotoWorker.requestPhotoAccess()
      let response = UserInfoScene.FetchUserPhotoAccess.Response(isPhotoAccessible: isPhotoAccessible)

      await self.presenter?.presentUserPhotoAccess(response: response)
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

          await self.presenter?.presentChangedProfileImage(response: response)
        }
      } catch let error {
        let response = UserInfoScene.ChangeProfileImage.Response(
          changeResult: Result.failure(error)
        )
        await self.presenter?.presentChangedProfileImage(response: response)
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
      await self.presenter?.presentWithdrawResult(response: response)
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
      await self.presenter?.presentSignOutResult(response: response)
    }
  }
}

// MARK: - Private Functions

extension UserInfoSceneInteractor {
  private func callPresenterWhenRequestArrived(
    for item: UserInfoScene.UserInfoItem
  ) async -> (UserInfoScene.UserInfoItem.Title, String) {
    let urlParameter = item.title.rawValue
    let value = await self.userInfoWorker.requestUserProfile(urlString: urlParameter)

    await MainActor.run {
      let response = UserInfoScene.FetchProfile.Response(description: value, item: item)
      self.presenter?.presentUserProfile(response: response)
    }

    return (item.title, value)
  }

  // TODO: TaskGroup을 전달하고 있는 행위 자체가 금기됨
  // childTask를 추가하고 있지 않지만, 그럴 우려가 높아짐.
  private func makeUserProfile(
    with taskGroup: TaskGroup<(UserInfoScene.UserInfoItem.Title, String)>
  ) async -> UserInfoScene.UserProfile {
    var profileData = [UserInfoScene.UserInfoItem.Title: String]()

    for await (itemTitle, value) in taskGroup {
      profileData[itemTitle] = value
    }

    return UserInfoScene.UserProfile(
      nickName: profileData[UserInfoScene.UserInfoItem.Title.nickName] ?? "",
      introduction: profileData[UserInfoScene.UserInfoItem.Title.introduction]
      ?? UserInfoSceneTheme.StringLiteral.UserInfoCollectionView.introductionNotExisted,
      id: profileData[UserInfoScene.UserInfoItem.Title.id] ?? "",
      email: profileData[UserInfoScene.UserInfoItem.Title.email] ?? ""
    )
  }
}
