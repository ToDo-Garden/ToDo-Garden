import Foundation

import TimerSceneEntity

protocol TimerSceneDataStore {
  // var name: String { get set }
}

@MainActor
protocol TimerSceneBusinessLogic {
  func buttonTapped()
  func doSomething(request: TimerScene.Something.Request)
}

@MainActor
final class TimerSceneInteractor: TimerSceneDataStore {
  // var name: String = ""
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
  func buttonTapped() {
    // TODO: Bottom Sheet
    let date = createDate(minutes: nil, seconds: 2)
    run {
      var isFirst = true
      for try await time in self.worker.countdownStream(date) {
        presenter?.updateTimeState(time, isFirst: isFirst)
        if isFirst {
          isFirst = false
        }
      }
    }
  }
  
  func createDate(minutes: Int?, seconds: Int) -> Date {
    let calendar = Calendar.current
    var dateComponents = DateComponents()
    dateComponents.minute = minutes
    dateComponents.second = seconds
    return calendar.date(from: dateComponents) ?? Date()
  }
  
  func doSomething(request: TimerScene.Something.Request) {
    //		self.someWorker.doSomeWork()
    
    let response = TimerScene.Something.Response()
    self.presenter?.presentSomething(response: response)
  }
}
