//
//  SettingRouter.swift
//  
//
//  Created by Wood on 8/5/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SettingSceneAPI

protocol SettingRoutingLogic {
}

protocol SettingDataPassing {
	var dataStore: SettingDataStore? { get }
}

class SettingRouter: SettingDataPassing {
	weak var viewController: SettingViewController?
	var dataStore: SettingDataStore?
}

// MARK: - Routing

extension SettingRouter: SettingRoutingLogic {
}

// MARK: - Declare Payload for scene

extension SettingRouter {
	struct NextScenePayload: NextScenePayloadable {
		// var name: String
	}
}
