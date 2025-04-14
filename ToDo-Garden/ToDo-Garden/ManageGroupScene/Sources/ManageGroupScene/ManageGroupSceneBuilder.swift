//
//  ManageGroupSceneBuilder.swift
//  
//
//  Created by SONG on 6/26/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import ManageGroupSceneAPI
import PostGroupSceneAPI
import TDFoundation
import ToDoGardenUIAPI

public struct ManageGroupSceneBuilder {
  /// 컴파일 타임에 필요한 의존성을 선언한 구조체입니다.
  public struct Dependency {
    let manageGroupWorker: ManageGroupWorkable
    let postGroupSceneBuilder: PostGroupSceneBuildable?
    let retryManager: NetworkRetryManagerAPI
    
    public init(
      manageGroupWorker: ManageGroupWorkable,
      postGroupSceneBuilder: PostGroupSceneBuildable?,
      retryManager: NetworkRetryManagerAPI
    ) {
      self.manageGroupWorker = manageGroupWorker
      self.postGroupSceneBuilder = postGroupSceneBuilder
      self.retryManager = retryManager
    }
  }
  
  private let dependency: Dependency
  
  public init(dependency: Dependency) {
    self.dependency = dependency
  }
}

extension ManageGroupSceneBuilder: ManageGroupSceneBuildable {
  ///  VIP Cycle, 런타임 의존성이 설정된 ViewController 인스턴스를 반환하는 함수입니다.
  /// - Parameter payload: 런타임에 전달받아야 하는 의존성입니다.
  /// - Returns: 런타임 의존성, VIP Cycle이 설정된 ViewController를 반환합니다.
  public func build() -> ManageGroupViewControllable {
    let manageGroupSceneViewController = self.configureVIPCycle(
      for: ManageGroupViewController()
    )
    
    return manageGroupSceneViewController
  }
}

extension ManageGroupSceneBuilder {
  /// VIP Cycle을 설정합니다.
  /// - Parameter viewController: VIPCycle을 설정할 viewController입니다.
  /// - Returns: VIP Cycle 설정이 완료된 `ViewControllable` 프로토콜을 준수한 `ViewController` 인스턴스를 반환합니다.
  private func configureVIPCycle(for viewController: ManageGroupViewController) -> ManageGroupViewController {
    let interactor = ManageGroupInteractor(
      worker: self.dependency.manageGroupWorker,
      retryManager: self.dependency.retryManager
    )
    
    let presenter = ManageGroupPresenter()
    let router = ManageGroupRouter(postSceneBuilder: self.dependency.postGroupSceneBuilder)
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
    
    return viewController
  }
}
