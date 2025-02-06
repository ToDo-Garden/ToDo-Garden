import Foundation

import TimerSceneAPI
import TimerSceneEntity

@MainActor
protocol TimerSceneBusinessLogic {
  func controlButtonTapped()
  func setTimer(for seconds: Double)
  func sendAlertAction(_ action: TimerScene.AlertAction)
  func setCurrentGroup(_ payload: TimerScenePayloadable)
  func requestPOST()
}

@MainActor
final class TimerSceneInteractor {
  public var isCountingDown: Bool = false
  public var alertStatus: TimerScene.TimerAlertStatus?
  public var bottomSheetStatus: TimerScene.BottomSheetStatus = .focus
  public var currentGroup: TimerScene.CurrentGroup
  
  var presenter: TimerScenePresentationLogic?
  private let timerWorker: TimerSceneWorkable
  private let storageWorker: TimerStorageWorkable
  
  public var tasks: [AnyHashable: Task<Void, Never>] = [:]
  
  init(
    timerWorker: TimerSceneWorkable,
    storageWorker: TimerStorageWorkable
  ) {
    self.timerWorker = timerWorker
    self.storageWorker = storageWorker
    self.currentGroup = TimerScene.CurrentGroup(groupId: "", groupName: "")
    // MARK: currentGroup은 Payload로 이전화면에서 전달받아 의미있는 값으로 대체됨
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
    case postItems
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
      for try await time in self.timerWorker.countDownStream(seconds) {
        let range = TimerScene.CircularProgressRange(1 - (time / seconds))
        self.presenter?.updateTimeState(time, range: range)
      }
      self.didCompleteTimer(seconds: Int(seconds))
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
    self.cancel(CancelTaskID.countdown)
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

extension TimerSceneInteractor {
  func didCompleteTimer(seconds: Int) {
    self.currentGroup.update(seconds: seconds)
    
    do {
      try self.storageWorker.recordCompletedItemInLocal(
        groupId: self.currentGroup.groupId,
        seconds: self.currentGroup.seconds
      )
    } catch let error {
      debugPrint(error)
    }
  }
  
  func setCurrentGroup(_ payload: TimerScenePayloadable) {
    self.currentGroup = TimerScene.CurrentGroup(
      groupId: payload.groupId,
      groupName: payload.groupName
    )
  }
}

extension TimerSceneInteractor {
  func requestPOST() {
    self.run(id: CancelTaskID.postItems) {
      try await self.storageWorker.postCompletedItem()
      try Task.checkCancellation()
    } errorHandler: { error in
      debugPrint(error)
    }
  }
    
}
