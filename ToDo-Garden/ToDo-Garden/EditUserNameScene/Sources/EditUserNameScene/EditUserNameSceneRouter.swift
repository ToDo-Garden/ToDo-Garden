//
//  EditUserNameSceneRouter.swift
//  
//
//  Created by Wood on 9/23/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import EditUserNameSceneAPI

protocol EditUserNameSceneRoutingLogic {
	func routeToSomewhere()
}

protocol EditUserNameSceneDataPassing {
	var dataStore: EditUserNameSceneDataStore? { get }
}

class EditUserNameSceneRouter: EditUserNameSceneDataPassing {
	weak var viewController: EditUserNameSceneViewController?
	var dataStore: EditUserNameSceneDataStore?
	private let nextSceneBuilder: NextSceneBuildable
	
	init(nextSceneBuilder: NextSceneBuildable) {
		self.nextSceneBuilder = nextSceneBuilder
	}
}

// MARK: - Routing

extension EditUserNameSceneRouter: EditUserNameSceneRoutingLogic {
	func routeToSomewhere() {
		let destinationViewController = self.nextSceneBuilder.build(with: NextScenePayload())
		
		self.viewController?.present(destinationViewController, animated: true)
	}
}

// MARK: - Declare Payload for scene

extension EditUserNameSceneRouter {
	struct NextScenePayload: NextScenePayloadable {
		// var name: String
	}
}
