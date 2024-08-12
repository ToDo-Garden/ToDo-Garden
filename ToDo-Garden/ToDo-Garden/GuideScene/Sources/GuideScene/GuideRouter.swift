//
//  GuideRouter.swift
//  GuideScene
//
//  Created by Cloud on 8/12/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

protocol GuideRoutingLogic {
	func routeToSomewhere()
}

protocol GuideDataPassing {
	var dataStore: GuideDataStore? { get }
}

class GuideRouter: GuideDataPassing {
	weak var viewController: GuideViewController?
	var dataStore: GuideDataStore?
	private let nextSceneBuilder: NextSceneBuildable
	
	init(nextSceneBuilder: NextSceneBuildable) {
		self.nextSceneBuilder = nextSceneBuilder
	}
}

// MARK: - Routing

extension GuideRouter: GuideRoutingLogic {
	func routeToSomewhere() {
		let destinationViewController = self.nextSceneBuilder.build(with: NextScenePayload())
		
		self.viewController?.present(destinationViewController, animated: true)
	}
}

// MARK: - Declare Payload for scene

extension GuideRouter {
	struct NextScenePayload: NextScenePayloadable {
		// var name: String
	}
}
