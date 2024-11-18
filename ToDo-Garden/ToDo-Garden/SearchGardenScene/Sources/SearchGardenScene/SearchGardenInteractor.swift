//
//  SearchGardenInteractor.swift
//  
//
//  Created by SONG on 11/18/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

protocol SearchGardenDataStore {
	// var name: String { get set }
}

protocol SearchGardenBusinessLogic {
	func doSomething(request: SearchGarden.Something.Request)
}

class SearchGardenInteractor: SearchGardenDataStore {
	// var name: String = ""
	var presenter: SearchGardenPresentationLogic?
	private let someWorker: SearchGardenWorkable
	
	init(someWorker: SearchGardenWorkable) {
		self.someWorker = someWorker
	}
}

// MARK: - Request to worker

extension SearchGardenInteractor: SearchGardenBusinessLogic {
	func doSomething(request: SearchGarden.Something.Request) {
		self.someWorker.doSomeWork()
		
		let response = SearchGarden.Something.Response()
		self.presenter?.presentSomething(response: response)
	}
}
