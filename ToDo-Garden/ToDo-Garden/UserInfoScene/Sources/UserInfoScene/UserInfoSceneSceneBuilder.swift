//
//  UserInfoSceneSceneBuilder.swift
//  
//
//  Created by Wood on 8/28/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import PhotosUI
import UIKit.UIApplication

import EditUserIntroductionSceneAPI
import EditUserNameSceneAPI
import HTTPClient
import UserInfoSceneAPI
import UserInfoSceneEntity

public struct UserInfoSceneSceneBuilder {
  /// 컴파일 타임에 필요한 의존성을 선언한 구조체입니다.
  public struct Dependency {
    let appServiceWorker: AppServiceWorkable
    let userPhotoWorker: UserPhotoWorker
    let userInfoWorker: UserInfoSceneWorkable
    let editUserIntroductionSceneBuilder: EditUserIntroductionSceneBuildable?
    let editUserNameSceneBuilder: EditUserNameSceneSceneBuildable?

    public init(
      appServiceWorker: AppServiceWorkable,
      userPhotoWorker: UserPhotoWorker,
      userInfoWorker: UserInfoSceneWorkable,
      editUserIntroductionSceneBuilder: EditUserIntroductionSceneBuildable?,
      editUserNameSceneBuilder: EditUserNameSceneSceneBuildable?
    ) {
      self.appServiceWorker = appServiceWorker
      self.userPhotoWorker = userPhotoWorker
      self.userInfoWorker = userInfoWorker
      self.editUserIntroductionSceneBuilder = editUserIntroductionSceneBuilder
      self.editUserNameSceneBuilder = editUserNameSceneBuilder
    }
  }

  private let dependency: Dependency
  
  public init(dependency: Dependency) {
    self.dependency = dependency
  }
}

extension UserInfoSceneSceneBuilder {
  public static func live(
    signout: @escaping () -> Void,
    editUserIntroductionSceneBuilder: EditUserIntroductionSceneBuildable? = nil,
    editUserNameSceneBuilder: EditUserNameSceneSceneBuildable? = nil
  ) -> Self {
    Self(dependency: Dependency(
      appServiceWorker: AppServiceWorker(),
      userPhotoWorker: UserPhotoWorker(),
      userInfoWorker: UserInfoSceneWorker(httpClient: HTTPClient.live, signout: signout),
      editUserIntroductionSceneBuilder: editUserIntroductionSceneBuilder,
      editUserNameSceneBuilder: editUserNameSceneBuilder)
    )
  }
}

extension UserInfoSceneSceneBuilder: UserInfoSceneSceneBuildable {
  ///  VIP Cycle, 런타임 의존성이 설정된 ViewController 인스턴스를 반환하는 함수입니다.
  /// - Parameter payload: 런타임에 전달받아야 하는 의존성입니다.
  /// - Returns: 런타임 의존성, VIP Cycle이 설정된 ViewController를 반환합니다.
  public func build() -> UserInfoSceneViewControllable {
    let userInfoSceneViewController = UserInfoSceneViewController()
    userInfoSceneViewController.photoPickerDelegate = self.dependency.userPhotoWorker
    let configuredVIPCycleViewController = self.configureVIPCycle(for: userInfoSceneViewController)
    return configuredVIPCycleViewController
  }
}

extension UserInfoSceneSceneBuilder {
  /// VIP Cycle을 설정합니다.
  /// - Parameter viewController: VIPCycle을 설정할 viewController입니다.
  /// - Returns: VIP Cycle 설정이 완료된 `ViewControllable` 프로토콜을 준수한 `ViewController` 인스턴스를 반환합니다.
  private func configureVIPCycle(for viewController: UserInfoSceneViewController) -> UserInfoSceneViewController {
    let interactor = UserInfoSceneInteractor(
      userInfoWorker: self.dependency.userInfoWorker,
      appServiceWorker: self.dependency.appServiceWorker,
      userPhotoWorker: self.dependency.userPhotoWorker
    )
    let presenter = UserInfoScenePresenter()
    let router = UserInfoSceneRouter(
      editUserIntroductionSceneBuilder: self.dependency.editUserIntroductionSceneBuilder,
      editUserNameSceneBuilder: self.dependency.editUserNameSceneBuilder
    )
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
    
    return viewController
  }
}
