//
//  MyStatsPresenter.swift
//  
//
//  Created by SONG on 11/13/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import MyStatsSceneEntity

protocol MyStatsPresentationLogic {
  func presentSomething(response: MyStats.Something.Response)
}

class MyStatsPresenter {
  weak var viewController: MyStatsDisplayLogic?
}

// MARK: - Request to ViewController

extension MyStatsPresenter: MyStatsPresentationLogic {
  func presentSomething(response: MyStats.Something.Response) {
    let viewModel = MyStats.Something.ViewModel()
    self.viewController?.displaySomething(viewModel: viewModel)
  }
}
