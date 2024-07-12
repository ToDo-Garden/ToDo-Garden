import Foundation

import TimerSceneEntity

protocol TimerSceneDataStore {
}

@MainActor
protocol TimerSceneBusinessLogic {
  func controlButtonTapped()
  func setTimer(for seconds: Double)
  func sendAlertAction(_ action: TimerScene.AlertAction)
}

@MainActor
final class TimerSceneInteractor: TimerSceneDataStore {
  var isCounting: Bool = false
  var alertStatus: TimerScene.TimerAlertStatus?
  var bottomSheetStatus: TimerScene.BottomSheetStatus = .concentrate
  
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
    if isCounting {
      self.alertStatus = self.bottomSheetStatus.alertStatus
      self.presenter?.showAlert(self.bottomSheetStatus.alertStatus)
    } else {
      self.presenter?.presentBottomSheet(self.bottomSheetStatus)
    }
  }

  func setTimer(for seconds: Double) {
    switch bottomSheetStatus {
    case .concentrate:
      self.countdown(for: seconds) { [weak self] in
        self?.presenter?.clearPresentState()
        self?.alertStatus = .welldone
        self?.presenter?.showAlert(.welldone)
      }
    case .resting:
      self.countdown(for: seconds) {
        self.presenter?.clearPresentState()
        self.presenter?.showAlert(.fullyCharged)
      }
    }
  }
  
  private func countdown(
    for seconds: Double,
    completion: @escaping () -> Void
  ) {
    run(id: CancelTaskID.countdown) {
      defer { self.isCounting = false }
      self.isCounting = true
      self.presenter?.configureTimerSettings(self.bottomSheetStatus, for: seconds)
      for try await time in self.worker.countDownSequence(2) {
        let range = TimerScene.CircularProgressRange(1 - (time / seconds))
        self.presenter?.updateTimeState(time, range: range)
      }
      completion()
    }
  }
  
  func sendAlertAction(_ action: TimerSceneEntity.TimerScene.AlertAction) {
    switch action {
    case .stopConcentration:
      stopConcentrationAction()
      
    case .keepConcentration:
      cancel(CancelTaskID.countdown)
      bottomSheetStatus = .concentrate
      presenter?.updateViewState(isResting: false)
      presenter?.presentBottomSheet(.concentrate)
    
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
      presenter?.updateViewState(isResting: false)
    } else if case .welldone = self.alertStatus {
      self.bottomSheetStatus = .resting
      presenter?.updateViewState(isResting: true)
    }
  }
}

extension TimerScene.BottomSheetStatus {
  var alertStatus: TimerScene.TimerAlertStatus {
    switch self {
    case .concentrate:
      return .stopConcentration
    case .resting:
      return .stopResting
    }
  }
  
  var bottomSheet: TimerScene.BottomSheetStatus {
    switch self {
    case .concentrate:
      return .concentrate
    case .resting:
      return .resting
    }
  }
}
