//
//  ManageGroupInteractor.swift
//  
//
//  Created by SONG on 6/26/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import ManageGroupSceneAPI
import ManageGroupSceneEntity

protocol ManageGroupDataStore {
	// var name: String { get set }
}

protocol ManageGroupBusinessLogic {
	func doSomething(request: ManageGroup.Something.Request)
}

class ManageGroupInteractor: ManageGroupDataStore {
	// var name: String = ""
	var presenter: ManageGroupPresentationLogic?
	private let someWorker: ManageGroupWorkable
	
	init(someWorker: ManageGroupWorkable) {
		self.someWorker = someWorker
	}
}

// MARK: - Request to worker

extension ManageGroupInteractor: ManageGroupBusinessLogic {
	func doSomething(request: ManageGroup.Something.Request) {
		self.someWorker.doSomeWork()
		
		let response = ManageGroup.Something.Response()
		self.presenter?.presentSomething(response: response)
	}
}
