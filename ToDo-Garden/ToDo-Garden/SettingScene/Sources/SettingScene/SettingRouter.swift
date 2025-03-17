//
//  SettingRouter.swift
//  
//
//  Created by Wood on 8/5/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import GuideScene
import SettingSceneAPI

protocol SettingRoutingLogic {
  func routeToGuideScene()
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
  func routeToGuideScene() {
    // TODO: GuideDetailViewController는 임시로 연결해놓았고, GuideDetailViewController로 진입할 수 있는 VC로 연결되어야함
    let guideSceneViewController = GuideDetailViewController(.todoEdit)
    guideSceneViewController.modalPresentationStyle = .fullScreen
    self.viewController?.present(guideSceneViewController, animated: true)
  }
}

// MARK: - Declare Payload for scene

extension SettingRouter {
	struct NextScenePayload: NextScenePayloadable {
		// var name: String
	}
}
