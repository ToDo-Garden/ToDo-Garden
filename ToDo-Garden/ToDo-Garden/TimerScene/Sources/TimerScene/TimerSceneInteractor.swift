import Foundation

import TimerSceneEntity

protocol TimerSceneDataStore {
}

@MainActor
protocol TimerSceneBusinessLogic {
  func controlButtonTapped()
}

@MainActor
final class TimerSceneInteractor: TimerSceneDataStore {
  var isFocused: Bool = false
  var presenter: TimerScenePresentationLogic?
  private let worker: TimerSceneWorkable
  
  private var tasks: [AnyHashable: Task<Void, Never>] = [:]
  
  init(worker: TimerSceneWorkable) {
    self.worker = worker
  }
  
  private func run(
    id: AnyHashable = UUID(),
    @_implicitSelfCapture work: @escaping () async throws -> Void,
    @_implicitSelfCapture errorHandler: @escaping (any Error) -> Void = { _ in }
  ) {
    let task = Task {
      defer { self.tasks[id] = nil }
      do {
        try await work()
      } catch {
        guard !(error is CancellationError) else { return }
        errorHandler(error)
      }
    }
    self.tasks[id] = task
  }
}

// MARK: - Request to worker

extension TimerSceneInteractor: TimerSceneBusinessLogic {
  
  func controlButtonTapped() {
    guard !self.isFocused else { return }
    // TODO: Bottom Sheet
    let seconds = 10.0
    
    self.isFocused = true
    run {
      self.presenter?.configureTimerSettings(seconds)
      for try await time in self.worker.countDownSequence(seconds) {
        let range = TimerScene.CircularProgressRange(1 - (time / seconds))
        self.presenter?.updateTimeState(time, range: range)
      }
      self.isFocused = false
    }
  }
}
