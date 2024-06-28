//
//  TimerSceneRouter.swift
//  
//
//  Created by Cloud on 6/17/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

protocol TimerSceneRoutingLogic {
	func routeToSomewhere()
}

protocol TimerSceneDataPassing {
	var dataStore: TimerSceneDataStore? { get }
}

class TimerSceneRouter: TimerSceneDataPassing {
	weak var viewController: TimerSceneViewController?
	var dataStore: TimerSceneDataStore?
	private let nextSceneBuilder: NextSceneBuildable
	
	init(nextSceneBuilder: NextSceneBuildable) {
		self.nextSceneBuilder = nextSceneBuilder
	}
}

// MARK: - Routing

extension TimerSceneRouter: TimerSceneRoutingLogic {
	func routeToSomewhere() {
//		let destinationViewController = self.nextSceneBuilder.build(with: NextScenePayload())
		
//		self.viewController?.present(destinationViewController, animated: true)
	}
}

// MARK: - Declare Payload for scene

extension TimerSceneRouter {
	struct NextScenePayload: NextScenePayloadable {
		// var name: String
	}
}
