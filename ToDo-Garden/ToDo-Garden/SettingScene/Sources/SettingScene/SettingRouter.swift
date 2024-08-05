//
//  SettingRouter.swift
//  
//
//  Created by Wood on 8/5/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SettingSceneAPI

protocol SettingRoutingLogic {
	func routeToSomewhere()
}

protocol SettingDataPassing {
	var dataStore: SettingDataStore? { get }
}

class SettingRouter: SettingDataPassing {
	weak var viewController: SettingViewController?
	var dataStore: SettingDataStore?
	private let nextSceneBuilder: NextSceneBuildable
	
	init(nextSceneBuilder: NextSceneBuildable) {
		self.nextSceneBuilder = nextSceneBuilder
	}
}

// MARK: - Routing

extension SettingRouter: SettingRoutingLogic {
	func routeToSomewhere() {
		let destinationViewController = self.nextSceneBuilder.build(with: NextScenePayload())
		
		self.viewController?.present(destinationViewController, animated: true)
	}
}

// MARK: - Declare Payload for scene

extension SettingRouter {
	struct NextScenePayload: NextScenePayloadable {
		// var name: String
	}
}
