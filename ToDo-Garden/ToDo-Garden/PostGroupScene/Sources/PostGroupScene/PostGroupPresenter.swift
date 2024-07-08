//
//  PostGroupPresenter.swift
//  
//
//  Created by SONG on 7/8/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import PostGroupSceneEntity

protocol PostGroupPresentationLogic {
  func presentSomething(response: PostGroup.Something.Response)
}

class PostGroupPresenter {
  weak var viewController: PostGroupDisplayLogic?
}

// MARK: - Request to ViewController

extension PostGroupPresenter: PostGroupPresentationLogic {
  func presentSomething(response: PostGroup.Something.Response) {
    let viewModel = PostGroup.Something.ViewModel()
    self.viewController?.displaySomething(viewModel: viewModel)
  }
}
