//
//  SettingPresenter.swift
//  
//
//  Created by Wood on 8/5/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SettingSceneEntity

protocol SettingPresentationLogic {
}

class SettingPresenter {
	weak var viewController: SettingDisplayLogic?
}

// MARK: - Request to ViewController

extension SettingPresenter: SettingPresentationLogic {
}
