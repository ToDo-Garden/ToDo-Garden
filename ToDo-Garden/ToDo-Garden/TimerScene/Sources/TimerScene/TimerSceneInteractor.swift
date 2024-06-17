import Foundation

import TimerSceneEntity

protocol TimerSceneDataStore {
	// var name: String { get set }
}

protocol TimerSceneBusinessLogic {
	func doSomething(request: TimerScene.Something.Request)
}

class TimerSceneInteractor: TimerSceneDataStore {
	// var name: String = ""
	var presenter: TimerScenePresentationLogic?
	private let someWorker: TimerSceneWorkable
	
	init(someWorker: TimerSceneWorkable) {
		self.someWorker = someWorker
	}
}

// MARK: - Request to worker

extension TimerSceneInteractor: TimerSceneBusinessLogic {
	func doSomething(request: TimerScene.Something.Request) {
		self.someWorker.doSomeWork()
		
		let response = TimerScene.Something.Response()
		self.presenter?.presentSomething(response: response)
	}
}
