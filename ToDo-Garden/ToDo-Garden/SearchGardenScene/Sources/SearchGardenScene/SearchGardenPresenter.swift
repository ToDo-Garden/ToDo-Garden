//
//  SearchGardenPresenter.swift
//  
//
//  Created by SONG on 11/18/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import SearchGardenSceneEntity

protocol SearchGardenPresentationLogic {
  func presentSomething(response: SearchGarden.Something.Response)
}

class SearchGardenPresenter {
  weak var viewController: SearchGardenDisplayLogic?
}

// MARK: - Request to ViewController

extension SearchGardenPresenter: SearchGardenPresentationLogic {
  func presentSomething(response: SearchGarden.Something.Response) {
    let viewModel = SearchGarden.Something.ViewModel()
    self.viewController?.displaySomething(viewModel: viewModel)
  }
}
