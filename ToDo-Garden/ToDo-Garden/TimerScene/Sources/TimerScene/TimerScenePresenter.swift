import Foundation
import UIKit

import TimerSceneEntity

@MainActor
protocol TimerScenePresentationLogic {
  func configureTimerSettings(_ targetTime: Double)
  func updateTimeState(_ seconds: Double, range: TimerScene.CircularProgressRange)
}

class TimerScenePresenter {
	weak var viewController: TimerSceneDisplayLogic?
}

// MARK: - Request to ViewController

extension TimerScenePresenter: TimerScenePresentationLogic {
  func configureTimerSettings(_ targetTime: Double) {
    viewController?.updateTargetLabel(time: convertMinutes(targetTime))
    viewController?.updateControlButton(isFocused: true)
  }
  
  func updateTimeState(_ seconds: Double, range: TimerScene.CircularProgressRange) {
    let flag = seconds != 0
    viewController?
      .updateTimeLabel(duration: seconds, time: convertTime(from: seconds), isFirst: flag)
    
    viewController?.updateProgressImage(range.image)
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
}

private extension TimerScene.CircularProgressRange {
  var image: UIImage {
    switch self {
    case .oneThird:
      return UIImage.progressLow
    case .twoThirds:
      return UIImage.progressMedium
    case .whole:
      return UIImage.progressHigh
    }
  }
}
