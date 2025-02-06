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
    case focus
    case rest
  }
  
  public struct CurrentGroup: Sendable {
    public let groupId: String
    public let groupName: String
    public var seconds: Int = Int.zero
    
    public init(groupId: String, groupName: String) {
      self.groupId = groupId
      self.groupName = groupName
    }
    
    public mutating func update(seconds: Int) {
      self.seconds = seconds
    }
  }
}

extension TimerScene {
  public struct FocusTimeRequestDTO: Codable, Sendable {
    public let pomodoros: [PomodoroDTO]
    
    public init(pomodoros: [PomodoroDTO]) {
      self.pomodoros = pomodoros
    }
  }

  public struct PomodoroDTO: Codable, Sendable {
    public let focusGroupId: String
    public let focusDate: String
    public var focusTime: [Int]
    
    public init(focusGroupId: String, focusDate: String, focusTime: [Int]) {
      self.focusGroupId = focusGroupId
      self.focusDate = focusDate
      self.focusTime = focusTime
    }
  }
}
