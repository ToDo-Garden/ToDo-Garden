//
//  SearchGardenRouter.swift
//  
//
//  Created by SONG on 11/18/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

protocol SearchGardenRoutingLogic {
	func routeToSomewhere()
}

protocol SearchGardenDataPassing {
	var dataStore: SearchGardenDataStore? { get }
}

class SearchGardenRouter: SearchGardenDataPassing {
	weak var viewController: SearchGardenViewController?
	var dataStore: SearchGardenDataStore?
	private let nextSceneBuilder: NextSceneBuildable
	
	init(nextSceneBuilder: NextSceneBuildable) {
		self.nextSceneBuilder = nextSceneBuilder
	}
}

// MARK: - Routing

extension SearchGardenRouter: SearchGardenRoutingLogic {
	func routeToSomewhere() {
		let destinationViewController = self.nextSceneBuilder.build(with: NextScenePayload())
		
		self.viewController?.present(destinationViewController, animated: true)
	}
}

// MARK: - Declare Payload for scene

extension SearchGardenRouter {
	struct NextScenePayload: NextScenePayloadable {
		// var name: String
	}
}
