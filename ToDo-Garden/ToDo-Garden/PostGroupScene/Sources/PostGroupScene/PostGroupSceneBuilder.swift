//
//  PostGroupSceneBuilder.swift
//
//
//  Created by SONG on 7/8/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit.UIButton

import PostGroupSceneAPI
import PostGroupSceneEntity
import ToDoGardenUIAPI

public struct PostGroupSceneBuilder {
  /// 컴파일 타임에 필요한 의존성을 선언한 구조체입니다.
  public struct Dependency {
    let postGroupWorker: PostGroupWorkable
    
    public init(
      postGroupWorker: PostGroupWorkable
    ) {
      self.postGroupWorker = postGroupWorker
    }
  }
  
  private let dependency: Dependency
  
  public init(dependency: Dependency) {
    self.dependency = dependency
  }
}

extension PostGroupSceneBuilder: PostGroupSceneBuildable {
  ///  VIP Cycle, 런타임 의존성이 설정된 ViewController 인스턴스를 반환하는 함수입니다.
  /// - Parameter payload: 런타임에 전달받아야 하는 의존성입니다.
  /// - Returns: 런타임 의존성, VIP Cycle이 설정된 ViewController를 반환합니다.
  public func build(
    with payload: PostGroupScenePayloadable?,
    delegate: PostGroupSceneDelegate?
  ) -> PostGroupViewControllable {
    let postGroupViewController = self.configureVIPCycle(
      for: PostGroupViewController()
    )
    self.setPayload(for: postGroupViewController, with: payload, delegate: delegate)
    
    return postGroupViewController
  }
}

extension PostGroupSceneBuilder {
  /// VIP Cycle을 설정합니다.
  /// - Parameter viewController: VIPCycle을 설정할 viewController입니다.
  /// - Returns: VIP Cycle 설정이 완료된 `ViewControllable` 프로토콜을 준수한 `ViewController` 인스턴스를 반환합니다.
  private func configureVIPCycle(for viewController: PostGroupViewController) -> PostGroupViewController {
    let interactor = PostGroupInteractor(postGroupWorker: self.dependency.postGroupWorker)
    let presenter = PostGroupPresenter()
    let router = PostGroupRouter()
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
  private func setPayload(
    for viewController: PostGroupViewController,
    with payload: PostGroupScenePayloadable?,
    delegate: PostGroupSceneDelegate?
  ) {
    viewController.router?.dataStore?.payload = payload
    viewController.router?.dataStore?.delegate = delegate
  }
}
