//
//  GuideSceneBuilder.swift
//  GuideScene
//
//  Created by Cloud on 8/12/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

public struct GuideSceneBuilder {
	/// 컴파일 타임에 필요한 의존성을 선언한 구조체입니다.
	public struct Dependency {
		let nextSceneBuilder: NextSceneBuildable
		
		public init(nextSceneBuilder: NextSceneBuildable) {
			self.nextSceneBuilder = nextSceneBuilder
		}
	}
	
	private let dependency: Dependency
	
	public init(dependency: Dependency) {
		self.dependency = dependency
	}
}

extension GuideSceneBuilder: GuideSceneBuildable {
	///  VIP Cycle, 런타임 의존성이 설정된 ViewController 인스턴스를 반환하는 함수입니다.
	/// - Parameter payload: 런타임에 전달받아야 하는 의존성입니다.
	/// - Returns: 런타임 의존성, VIP Cycle이 설정된 ViewController를 반환합니다.
	public func build(with payload: GuideScenePayloadable) -> GuideViewControllable {
		let someViewController = self.configureVIPCycle(for: GuideViewController())
		self.setPayload(for: someViewController, with: payload)
		
		return someViewController
	}
}

extension GuideSceneBuilder {
	/// VIP Cycle을 설정합니다.
	/// - Parameter viewController: VIPCycle을 설정할 viewController입니다.
	/// - Returns: VIP Cycle 설정이 완료된 `ViewControllable` 프로토콜을 준수한 `ViewController` 인스턴스를 반환합니다.
	private func configureVIPCycle(for viewController: GuideViewController) -> GuideViewController {
		let interactor = GuideInteractor()
		let presenter = GuidePresenter()
		let router = GuideRouter(nextSceneBuilder: self.dependency.nextSceneBuilder)
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
	private func setPayload(for viewController: GuideViewController, with payload: GuideScenePayloadable) {
		// viewController.router?.dataStore?.name = payload.name
	}
}
