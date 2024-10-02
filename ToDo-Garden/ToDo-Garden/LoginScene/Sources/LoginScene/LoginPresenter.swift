//
//  LoginPresenter.swift
//  
//
//  Created by SONG on 10/2/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import LoginSceneEntity

protocol LoginPresentationLogic {
	func presentSomething(response: Login.Something.Response)
}

class LoginPresenter {
	weak var viewController: LoginDisplayLogic?
}

// MARK: - Request to ViewController

extension LoginPresenter: LoginPresentationLogic {
	func presentSomething(response: Login.Something.Response) {
		let viewModel = Login.Something.ViewModel()
		self.viewController?.displaySomething(viewModel: viewModel)
	}
}
