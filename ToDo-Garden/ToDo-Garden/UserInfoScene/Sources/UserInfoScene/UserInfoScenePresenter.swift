//
//  UserInfoScenePresenter.swift
//
//
//  Created by Wood on 8/28/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import UserInfoSceneEntity

@MainActor
protocol UserInfoScenePresentationLogic {
  func presentCollectionViewSections()
  func presentUserProfile(response: UserInfoScene.FetchProfile.Response)
  func presentUserPhotoAccess(response: UserInfoScene.FetchUserPhotoAccess.Response)
  func presentChangedProfileImage(response: UserInfoScene.ChangeProfileImage.Response)
  func presentWithdrawResult(response: UserInfoScene.WithdrawMembership.Response)
  func presentSignOutResult(response: UserInfoScene.SignOut.Response)
  func presentChangedUserIntroduction(_ userIntroduction: String)
  func presentEmptyUserIntroduction()
}

final class UserInfoScenePresenter {
  weak var viewController: UserInfoSceneDisplayLogic?
}

// MARK: - Request to ViewController

extension UserInfoScenePresenter: UserInfoScenePresentationLogic {
  nonisolated func presentCollectionViewSections() {
    let collectionViewSections = self.makeCollectionViewSections()
    let viewModel = UserInfoScene.ConfigureCollectionView.ViewModel(userInfoSections: collectionViewSections)
    self.viewController?.displayCollectionViewSections(viewModel: viewModel)
  }

  func presentUserProfile(response: UserInfoScene.FetchProfile.Response) {
    let description = response.description
    let item = response.item
    let viewModel = UserInfoScene.FetchProfile.ViewModel(description: description, item: item)
    self.viewController?.displayFetchedProfile(viewModel: viewModel)
  }

  func presentUserPhotoAccess(response: UserInfoScene.FetchUserPhotoAccess.Response) {
    let isPhotoAccessible = response.isPhotoAccessible
    let viewModel = UserInfoScene.FetchUserPhotoAccess.ViewModel(isPhotoAccessible: isPhotoAccessible)
    self.viewController?.displayUserPhotoAccess(viewModel: viewModel)
  }

  func presentChangedProfileImage(response: UserInfoScene.ChangeProfileImage.Response) {
    let changeResult = response.changeResult
    let viewModel = UserInfoScene.ChangeProfileImage.ViewModel(changeResult: changeResult)
    self.viewController?.displayChangedProfileImage(viewModel: viewModel)
  }

  func presentWithdrawResult(response: UserInfoScene.WithdrawMembership.Response) {
    let withdrawError = response.withdrawError
    let viewModel = UserInfoScene.WithdrawMembership.ViewModel(withdrawError: withdrawError)
    self.viewController?.displayWithdrawResult(viewModel: viewModel)
  }

  func presentSignOutResult(response: UserInfoScene.SignOut.Response) {
    let signOutError = response.signOutError
    let viewModel = UserInfoScene.SignOut.ViewModel(signOutError: signOutError)
    self.viewController?.displaySignOutResult(viewModel: viewModel)
  }

  func presentChangedUserIntroduction(_ userIntroduction: String) {
    self.viewController?.displayChangedUserIntroduction(userIntroduction)
  }

  func presentEmptyUserIntroduction() {
    self.viewController?.displayEmptyUserIntroduction(Self.userIntroductionPlaceholderText)
  }
}

extension UserInfoScenePresenter {
  private func makeCollectionViewSections() -> [UserInfoScene.UserInfoSection] {
    let sectionTitle = UserInfoSceneTheme.StringLiteral.UserInfoCollectionView.Section.self
    let itemTitle = UserInfoSceneTheme.StringLiteral.UserInfoCollectionView.Item.self
    let profileSection = UserInfoScene.UserInfoSection(
      title: sectionTitle.profileSetting,
      items: [
        UserInfoScene.UserInfoItem(userInfo: .nickName, title: itemTitle.nickName, isRightImageExisted: true),
        UserInfoScene.UserInfoItem(userInfo: .introduction, title: itemTitle.introduction, isRightImageExisted: true)
      ]
    )

    let accountSection = UserInfoScene.UserInfoSection(
      title: sectionTitle.accountSetting,
      items: [
        UserInfoScene.UserInfoItem(userInfo: .id, title: itemTitle.id, isRightImageExisted: true),
        UserInfoScene.UserInfoItem(userInfo: .email, title: itemTitle.email, isRightImageExisted: false)
      ]
    )

    return [profileSection, accountSection]
  }

  static let userIntroductionPlaceholderText = "소개글을 입력해주세요"
}
