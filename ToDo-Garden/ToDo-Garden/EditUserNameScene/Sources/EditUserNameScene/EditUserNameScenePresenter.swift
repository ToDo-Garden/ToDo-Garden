//
//  EditUserNameScenePresenter.swift
//  
//
//  Created by Wood on 9/23/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import EditUserNameSceneEntity

protocol EditUserNameScenePresentationLogic {
}

class EditUserNameScenePresenter {
  weak var viewController: EditUserNameSceneDisplayLogic?
}

// MARK: - Request to ViewController

extension EditUserNameScenePresenter: EditUserNameScenePresentationLogic {
}
