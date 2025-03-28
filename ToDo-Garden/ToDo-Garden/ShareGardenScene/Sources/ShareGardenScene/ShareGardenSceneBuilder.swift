//
//  ShareGardenSceneSceneBuilder.swift
//
//
//  Created by Noah on 7/4/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SearchGardenSceneAPI
import ShareGardenSceneAPI

@MainActor
public struct ShareGardenSceneBuilder {
  /// 컴파일 타임에 필요한 의존성을 선언한 구조체입니다.
  public struct Dependency {
    let shareGardenSceneWorker: ShareGardenSceneWorkable
    let searchGardenSceneBuilder: SearchGardenSceneBuildable
    
    public init(
      shareGardenSceneWorker: ShareGardenSceneWorkable,
      searchGardenSceneBuilder: SearchGardenSceneBuildable
    ) {
      self.shareGardenSceneWorker = shareGardenSceneWorker
      self.searchGardenSceneBuilder = searchGardenSceneBuilder
    }
  }
  
  private let dependency: Dependency
  
  public init(dependency: Dependency) {
    self.dependency = dependency
  }
}

extension ShareGardenSceneBuilder: ShareGardenSceneBuildable {
  ///  VIP Cycle, 런타임 의존성이 설정된 ViewController 인스턴스를 반환하는 함수입니다.
  /// - Returns: 런타임 의존성, VIP Cycle이 설정된 ViewController를 반환합니다.
  public func build() -> ShareGardenSceneViewControllable {
    let shareGardenScene = self.configuredVIPCycleShareGardenScene()
    
    return shareGardenScene
  }
}

extension ShareGardenSceneBuilder {
  /// VIP Cycle을 설정합니다.
  /// - Returns: VIP Cycle 설정이 완료된 `ViewControllable` 프로토콜을 준수한 `ViewController` 인스턴스를 반환합니다.
  private func configuredVIPCycleShareGardenScene() -> ShareGardenSceneViewController {
    let interactor = ShareGardenSceneInteractor(shareGardenSceneWorker: self.dependency.shareGardenSceneWorker)
    let viewController = ShareGardenSceneViewController(friendsGardenStore: interactor)
    let presenter = ShareGardenScenePresenter()
    let router = ShareGardenSceneRouter(searchGardenSceneBuilder: self.dependency.searchGardenSceneBuilder)
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
    
    return viewController
  }
}

extension ShareGardenSceneBuilder.Dependency {
#if DEBUG
  @MainActor
  public static let preview = Self(
    shareGardenSceneWorker: ShareGardenSceneWorkerStub(),
    searchGardenSceneBuilder: SearchGardenBuilderStub()
  )
#endif
}
