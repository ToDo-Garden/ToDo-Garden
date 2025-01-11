//
//  SearchGardenSceneBuilder.swift
//  
//
//  Created by SONG on 11/18/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SearchGardenSceneAPI
import SearchGardenSceneEntity

public struct SearchGardenSceneBuilder {
  /// 컴파일 타임에 필요한 의존성을 선언한 구조체입니다.
  public struct Dependency {
    let searchGardenWorker: SearchGardenWorkable
    
    public init(searchGardenWorker: SearchGardenWorkable) {
      self.searchGardenWorker = searchGardenWorker
    }
  }
  
  private let dependency: Dependency
  
  public init(dependency: Dependency) {
    self.dependency = dependency
  }
}

extension SearchGardenSceneBuilder: SearchGardenSceneBuildable {
  ///  VIP Cycle, 런타임 의존성이 설정된 ViewController 인스턴스를 반환하는 함수입니다.
  /// - Parameter payload: 런타임에 전달받아야 하는 의존성입니다.
  /// - Returns: 런타임 의존성, VIP Cycle이 설정된 ViewController를 반환합니다.
  public func build() -> SearchGardenViewControllable {
    let someViewController = self.configureVIPCycle(for: SearchGardenViewController())
    return someViewController
  }
}

extension SearchGardenSceneBuilder {
  /// VIP Cycle을 설정합니다.
  /// - Parameter viewController: VIPCycle을 설정할 viewController입니다.
  /// - Returns: VIP Cycle 설정이 완료된 `ViewControllable` 프로토콜을 준수한 `ViewController` 인스턴스를 반환합니다.
  private func configureVIPCycle(for viewController: SearchGardenViewController) -> SearchGardenViewController {
    let interactor = SearchGardenInteractor(searchGardenWorker: self.dependency.searchGardenWorker)
    let presenter = SearchGardenPresenter()
    let router = SearchGardenRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
    
    return viewController
  }
}
