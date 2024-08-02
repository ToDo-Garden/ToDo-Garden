import Foundation

import TimerSceneEntity

@MainActor
protocol TimerSceneBusinessLogic {
  func controlButtonTapped()
  func setTimer(for seconds: Double)
  func sendAlertAction(_ action: TimerScene.AlertAction)
}

@MainActor
final class TimerSceneInteractor {
  public var isCountingDown: Bool = false
  public var alertStatus: TimerScene.TimerAlertStatus?
  public var bottomSheetStatus: TimerScene.BottomSheetStatus = .focus
  
  var presenter: TimerScenePresentationLogic?
  private let worker: TimerSceneWorkable
  
  public var tasks: [AnyHashable: Task<Void, Never>] = [:]
  
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
  
  enum CancelTaskID: Hashable {
    case countdown
  }
  private func cancel(_ id: AnyHashable) {
    self.tasks[id]?.cancel()
    self.tasks[id] = nil
  }
}

// MARK: - Request to worker
extension TimerSceneInteractor: TimerSceneBusinessLogic {
  func controlButtonTapped() {
    if self.isCountingDown {
      self.updateAndPresentAlertStatus(self.bottomSheetStatus.countDownInterruptAlert)
    } else {
      self.presenter?.presentBottomSheet(self.bottomSheetStatus)
    }
  }

  func setTimer(for seconds: Double) {
    self.isCountingDown = true
    run(id: CancelTaskID.countdown) {
      defer { self.isCountingDown = false }
      self.presenter?.configureTimerSettings(self.bottomSheetStatus, for: seconds)
      for try await time in self.worker.countDownStream(seconds) {
        let range = TimerScene.CircularProgressRange(1 - (time / seconds))
        self.presenter?.updateTimeState(time, range: range)
      }
      try Task.checkCancellation()
      self.presenter?.clearPresentState()
      self.updateAndPresentAlertStatus(self.bottomSheetStatus.completionAlertStatus)
    }
  }
  
  private func updateAndPresentAlertStatus(_ status: TimerScene.TimerAlertStatus) {
    self.alertStatus = status
    self.presenter?.showAlert(status)
  }
  
  func sendAlertAction(_ action: TimerSceneEntity.TimerScene.AlertAction) {
    switch action {
    case .stopConcentration:
      self.stopConcentrationAction()
      
    case .keepConcentration:
      self.keepConcentrationAction()
    
    case .goHome:
      self.presenter?.dismiss()
    
    case .cancel:
      break
    }
  }
  
  private func stopConcentrationAction() {
    if case .stopConcentration = self.alertStatus {
      self.alertStatus = nil
      self.cancel(CancelTaskID.countdown)
      self.presenter?.updateViewState(isResting: false)
    } else if case .welldone = self.alertStatus {
      self.bottomSheetStatus = .rest
      self.presenter?.updateViewState(isResting: true)
    }
  }
  
  private func keepConcentrationAction() {
    self.bottomSheetStatus = .focus
    self.presenter?.updateViewState(isResting: false)
    self.presenter?.presentBottomSheet(.focus)
  }
}

extension TimerScene.BottomSheetStatus {
  var countDownInterruptAlert: TimerScene.TimerAlertStatus {
    switch self {
    case .focus:
      return .stopConcentration
    case .rest:
      return .stopResting
    }
  }
  
  var completionAlertStatus: TimerScene.TimerAlertStatus {
    switch self {
    case .focus:
      return .welldone
    case .rest:
      return .fullyCharged
    }
  }
}
