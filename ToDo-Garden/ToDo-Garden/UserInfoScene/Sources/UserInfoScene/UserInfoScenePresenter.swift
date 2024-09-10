//
//  UserInfoScenePresenter.swift
//  
//
//  Created by Wood on 8/28/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import UserInfoSceneEntity

protocol UserInfoScenePresentationLogic {
  func presentCollectionViewSections(response: UserInfoScene.ConfigureCollectionView.Response)
  func presentUserProfile(response: UserInfoScene.FetchProfile.Response)
  func presentUserPhotoAccess(response: UserInfoScene.FetchUserPhotoAccess.Response)
  func presentChangedProfileImage(response: UserInfoScene.ChangeProfileImage.Response)
  func presentWithdrawResult(response: UserInfoScene.WithdrawMembership.Response)
}

final class UserInfoScenePresenter {
  weak var viewController: UserInfoSceneDisplayLogic?
}

// MARK: - Request to ViewController

extension UserInfoScenePresenter: UserInfoScenePresentationLogic {
  func presentCollectionViewSections(response: UserInfoScene.ConfigureCollectionView.Response) {
    let userInfoSections = response.userInfoSections
    let viewModel = UserInfoScene.ConfigureCollectionView.ViewModel(userInfoSections: userInfoSections)
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
}
