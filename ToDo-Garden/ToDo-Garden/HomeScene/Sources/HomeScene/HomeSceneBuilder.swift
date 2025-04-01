//
//  HomeSceneSceneBuilder.swift
//  HomeScene
//
//  Created by Noah on 1/9/25.
//  Copyright (c) 2025 ToDoGarden. All rights reserved.

import Foundation

import EditToDoSceneAPI
import HomeSceneAPI
import ManageGroupSceneAPI
import TDFoundation
import TimerSceneAPI

@MainActor
public struct HomeSceneBuilder {
  /// 컴파일 타임에 필요한 의존성을 선언한 구조체입니다.
  public struct Dependency {
    let homeSceneWorker: HomeSceneWorkable
    let manageGroupSceneBuilder: ManageGroupSceneBuildable
    let editToDoSceneBuilder: EditToDoSceneBuildable
    let timerSceneBuilder: TimerSceneBuildable
    let retryManager: NetworkRetryManagerAPI
    
    public init(
      homeSceneWorker: HomeSceneWorkable,
      manageGroupSceneBuilder: ManageGroupSceneBuildable,
      editToDoSceneBuilder: EditToDoSceneBuildable,
      timerSceneBuilder: TimerSceneBuildable,
      retryManager: NetworkRetryManagerAPI
    ) {
      self.homeSceneWorker = homeSceneWorker
      self.manageGroupSceneBuilder = manageGroupSceneBuilder
      self.editToDoSceneBuilder = editToDoSceneBuilder
      self.timerSceneBuilder = timerSceneBuilder
      self.retryManager = retryManager
    }
  }
  
  private let dependency: Dependency
  
  public init(dependency: Dependency) {
    self.dependency = dependency
  }
}

extension HomeSceneBuilder: HomeSceneBuildable {
  ///  VIP Cycle, 런타임 의존성이 설정된 ViewController 인스턴스를 반환하는 함수입니다.
  /// - Parameter payload: 런타임에 전달받아야 하는 의존성입니다.
  /// - Returns: 런타임 의존성, VIP Cycle이 설정된 ViewController를 반환합니다.
  public func build() -> HomeSceneViewControllable {
    let homeViewController = self.configureVIPCycle(for: HomeSceneViewController())
    self.setPayload(for: homeViewController)
    
    return homeViewController
  }
}

extension HomeSceneBuilder {
  /// VIP Cycle을 설정합니다.
  /// - Parameter viewController: VIPCycle을 설정할 viewController입니다.
  /// - Returns: VIP Cycle 설정이 완료된 `ViewControllable` 프로토콜을 준수한 `ViewController` 인스턴스를 반환합니다.
  @MainActor
  private func configureVIPCycle(for viewController: HomeSceneViewController) -> HomeSceneViewController {
    let interactor = HomeSceneInteractor(
      homeSceneWorker: self.dependency.homeSceneWorker,
      retryManager: self.dependency.retryManager
    )
    let presenter = HomeScenePresenter()
    let router = HomeSceneRouter(
      manageGroupSceneBuilder: self.dependency.manageGroupSceneBuilder,
      editToDoSceneBuilder: self.dependency.editToDoSceneBuilder,
      timerSceneBuilder: self.dependency.timerSceneBuilder
    )
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
    
    return viewController
  }
  
  /// ViewController에 런타임 파라미터 `payload`를 설정합니다.
  /// - Parameters:
  ///   - viewController: 런타임 의존성을 설정할 ViewController 객체입니다.
  ///   - payload: 런타임에 전달할 의존성입니다.
  private func setPayload(for viewController: HomeSceneViewController) {
    // viewController.router?.dataStore?.name = payload.name
  }
}
