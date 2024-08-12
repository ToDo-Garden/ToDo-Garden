//
//  GuidePresenter.swift
//  GuideScene
//
//  Created by Cloud on 8/12/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

protocol GuidePresentationLogic {
	func presentSomething(response: Guide.Something.Response)
}

class GuidePresenter {
	weak var viewController: GuideDisplayLogic?
}

// MARK: - Request to ViewController

extension GuidePresenter: GuidePresentationLogic {
	func presentSomething(response: Guide.Something.Response) {
		let viewModel = Guide.Something.ViewModel()
		self.viewController?.displaySomething(viewModel: viewModel)
	}
}
