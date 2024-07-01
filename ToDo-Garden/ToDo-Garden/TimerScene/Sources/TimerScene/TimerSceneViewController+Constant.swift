import Foundation

extension TimerSceneViewController {
  enum Constant {
    enum Layout { }
  }
}

extension TimerSceneViewController.Constant {
  enum DefaultViewState {
    static let targetLabel: String = "집중시간"
    static let timeLabel: String = "00:00"
    static let setTimerButton: String = "집중시간 설정"
  }
  
  enum TargetLabel {
    static func updated(_ minutes: String) -> String {
      "집중시간 \(minutes)분"
    }
  }
  
  enum ControlButton {
    static let setFocusTime: String = "집중시간 설정"
    static let giveUp: String = "포기할래요"
  }
}

extension TimerSceneViewController.Constant.Layout {
  enum BaseStack {
    static let topPadding: CGFloat = 94
  }
  enum TimerProgressView {
    static let innerPadding: CGFloat = 16
    static let bottomPadding: CGFloat = 55
    static let width: CGFloat = 236
    static let height: CGFloat = 236
  }
  
  enum ControlButton {
    static let width: CGFloat = 131
  }
  
  enum TargetLabel {
    static let width: CGFloat = 100
    static let height: CGFloat = 31
    static let bottomPadding: CGFloat = 9
  }
  
  enum TimeLabel {
    static let bottomPadding: CGFloat = 21
  }
  
  enum SetTimerButton {
    static let animationDuration: CGFloat = 0.15
    static let animationScale: CGFloat = 0.98
  }
}
