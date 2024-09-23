//
//  EditUserNameSceneInteractor.swift
//  
//
//  Created by Wood on 9/23/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import EditUserNameSceneAPI
import EditUserNameSceneEntity

protocol EditUserNameSceneDataStore {
	// var name: String { get set }
}

protocol EditUserNameSceneBusinessLogic {
	func doSomething(request: EditUserNameScene.Something.Request)
}

class EditUserNameSceneInteractor: EditUserNameSceneDataStore {
	// var name: String = ""
	var presenter: EditUserNameScenePresentationLogic?
	private let someWorker: EditUserNameSceneWorkable
	
	init(someWorker: EditUserNameSceneWorkable) {
		self.someWorker = someWorker
	}
}

// MARK: - Request to worker

extension EditUserNameSceneInteractor: EditUserNameSceneBusinessLogic {
	func doSomething(request: EditUserNameScene.Something.Request) {
		self.someWorker.doSomeWork()
		
		let response = EditUserNameScene.Something.Response()
		self.presenter?.presentSomething(response: response)
	}
}
