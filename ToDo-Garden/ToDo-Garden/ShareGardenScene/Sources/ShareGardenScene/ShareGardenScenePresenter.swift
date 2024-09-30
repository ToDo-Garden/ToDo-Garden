//
//  ShareGardenScenePresenter.swift
//
//
//  Created by Noah on 7/4/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import ShareGardenSceneEntity

@MainActor
protocol ShareGardenScenePresentationLogic {
}

final class ShareGardenScenePresenter {
  weak var viewController: ShareGardenSceneDisplayLogic?
}

// MARK: - Request to ViewController

extension ShareGardenScenePresenter: ShareGardenScenePresentationLogic {
}
