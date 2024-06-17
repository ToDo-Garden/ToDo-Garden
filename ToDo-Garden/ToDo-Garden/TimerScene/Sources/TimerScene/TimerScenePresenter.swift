import Foundation

import TimerSceneEntity

@MainActor
protocol TimerScenePresentationLogic {
	func presentSomething(response: TimerScene.Something.Response)
  func updateTimeState(_ time: Double, isFirst: Bool)
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
  
  func updateTimeState(_ time: Double, isFirst: Bool) {
    viewController?.updateTimeLabel(time: time, isFirst: isFirst)
  }
}
