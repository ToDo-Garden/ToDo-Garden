import Foundation

public enum TimerScene {
  public enum CircularProgressRange {
    case oneThird
    case twoThirds
    case whole
    
    public init(_ percent: Double) {
      switch percent {
      case 0.0..<0.3:
        self = .oneThird
      case 0.3..<0.6:
        self = .twoThirds
      default:
        self = .whole
      }
    }
  }
  
  public enum TimerAlertStatus: Sendable, Equatable {
    case fullyCharged
    case stopResting
    case welldone
    case stopConcentration
  }
  
  public enum AlertAction: Sendable, Equatable {
    case cancel
    case goHome
    case stopConcentration
    case keepConcentration
  }
  
  public enum BottomSheetStatus: Sendable, Equatable {
    case concentrate
    case resting
  }
}
