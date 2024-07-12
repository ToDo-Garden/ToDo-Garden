import UIKit

import TimerSceneEntity
import ToDoGardenUIComponent

@MainActor
protocol TimerScenePresentationLogic {
  func updateViewState(isResting: Bool)
  func configureTimerSettings(_ status: TimerScene.BottomSheetStatus, for targetTime: Double)
  func updateTimeState(_ seconds: Double, range: TimerScene.CircularProgressRange)
  
  func showAlert(_ status: TimerScene.TimerAlertStatus)
  func presentBottomSheet(_ status: TimerScene.BottomSheetStatus)
  func clearPresentState()
  func dismiss()
}

final class TimerScenePresenter {
	weak var viewController: TimerSceneDisplayLogic?
}

// MARK: - Request to ViewController
extension TimerScenePresenter: TimerScenePresentationLogic {
  func updateViewState(isResting: Bool) {
    if isResting {
      viewController?.updateRestingState()
    } else {
      viewController?.updateDefaultState()
    }
  }
  
  func configureTimerSettings(
    _ status: TimerScene.BottomSheetStatus,
    for targetTime: Double
  ) {
    self.viewController?.updateTargetLabel(time: self.convertMinutes(targetTime))
    self.viewController?.updateControllerButton(isConcentrating: status == .concentrate)
  }
  
  func updateTimeState(_ seconds: Double, range: TimerScene.CircularProgressRange) {
    let flag = seconds != 0
    self.viewController?
      .updateTimeLabel(duration: seconds, time: self.convertTime(from: seconds), isFirst: flag)
    
    self.viewController?.updateProgressImage(range.image)
  }
  
  private func convertTime(from seconds: Double) -> String {
    let secondsPerHour = 3600
    let secondsPerMinute = 60
    
    let totalSeconds = Int(seconds)
    let hours = totalSeconds / secondsPerHour
    let minutes = (totalSeconds % secondsPerHour) / secondsPerMinute
    let seconds = totalSeconds % secondsPerMinute

    return hours > 0
    ? String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    : String(format: "%02d:%02d", minutes, seconds)
  }
  
  private func convertMinutes(_ seconds: Double) -> String {
    let secondsPerMinute = 60.0
    return "\(Int(seconds / secondsPerMinute))"
  }
  
  func showAlert(_ status: TimerScene.TimerAlertStatus) {
    viewController?.showAlert(status.configuration)
  }
  
  func presentBottomSheet(_ status: TimerScene.BottomSheetStatus) {
    viewController?.presentBottomSheet(status.configuration)
  }
  
  func clearPresentState() {
    viewController?.clearPresentState()
  }
  
  func dismiss() {
    viewController?.dismiss()
  }
}

private extension TimerScene.CircularProgressRange {
  var image: UIImage {
    switch self {
    case Self.oneThird:
      return UIImage.progressLow
    case Self.twoThirds:
      return UIImage.progressMedium
    case Self.whole:
      return UIImage.progressHigh
    }
  }
}

private extension TimerScene.TimerAlertStatus {
  var configuration: ToDoGardenAlertView.Configuration {
    switch self {
    case .fullyCharged:
      return .fullyCharged
    case .stopResting:
      return .askToStopResting
    case .welldone:
      return .welldone
    case .stopConcentration:
      return .askToStop
    }
  }
}

private extension TimerScene.BottomSheetStatus {
  var configuration: SettingTimeView.Configuration {
    switch self {
    case .concentrate:
      return .focusTimeSetting
    case .resting:
      return .breakTimeSetting
    }
  }
}
