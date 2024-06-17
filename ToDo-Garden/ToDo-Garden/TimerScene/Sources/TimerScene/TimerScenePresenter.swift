import Foundation

import TimerSceneEntity

protocol TimerScenePresentationLogic {
	func presentSomething(response: TimerScene.Something.Response)
}

class TimerScenePresenter {
	weak var viewController: TimerSceneDisplayLogic?
}

// MARK: - Request to ViewController

extension TimerScenePresenter: TimerScenePresentationLogic {
	func presentSomething(response: TimerScene.Something.Response) {
		let viewModel = TimerScene.Something.ViewModel()
		self.viewController?.displaySomething(viewModel: viewModel)
	}
}
