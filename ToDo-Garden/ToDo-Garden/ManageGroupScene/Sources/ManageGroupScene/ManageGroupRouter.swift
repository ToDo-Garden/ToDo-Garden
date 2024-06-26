//
//  ManageGroupRouter.swift
//  
//
//  Created by SONG on 6/26/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import ManageGroupSceneAPI

protocol ManageGroupRoutingLogic {
	func routeToSomewhere()
}

protocol ManageGroupDataPassing {
	var dataStore: ManageGroupDataStore? { get }
}

class ManageGroupRouter: ManageGroupDataPassing {
	weak var viewController: ManageGroupViewController?
	var dataStore: ManageGroupDataStore?
	private let nextSceneBuilder: NextSceneBuildable
	
	init(nextSceneBuilder: NextSceneBuildable) {
		self.nextSceneBuilder = nextSceneBuilder
	}
}

// MARK: - Routing

extension ManageGroupRouter: ManageGroupRoutingLogic {
	func routeToSomewhere() {
		let destinationViewController = self.nextSceneBuilder.build(with: NextScenePayload())
		
		self.viewController?.present(destinationViewController, animated: true)
	}
}

// MARK: - Declare Payload for scene

extension ManageGroupRouter {
	struct NextScenePayload: NextScenePayloadable {
		// var name: String
	}
}
