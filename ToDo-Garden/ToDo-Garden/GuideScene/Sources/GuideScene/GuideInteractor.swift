//
//  GuideInteractor.swift
//  GuideScene
//
//  Created by Cloud on 8/12/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

protocol GuideDataStore {
	// var name: String { get set }
}

protocol GuideBusinessLogic {
	func doSomething(request: Guide.Something.Request)
}

class GuideInteractor: GuideDataStore {
	var presenter: GuidePresentationLogic?
	
	init() {
	}
}

// MARK: - Request to worker

extension GuideInteractor: GuideBusinessLogic {
	func doSomething(request: Guide.Something.Request) {
	}
}
