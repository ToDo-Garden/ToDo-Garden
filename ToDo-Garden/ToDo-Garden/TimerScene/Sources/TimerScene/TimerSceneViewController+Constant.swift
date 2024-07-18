import Foundation

extension TimerSceneViewController {
  enum Constant {
    enum Layout { }
  }
}

extension TimerSceneViewController.Constant {
  enum DefaultViewState {
    static let targetLabel: String = "집중시간"
    static let setTimerButton: String = "집중시간 설정"
    static let setTimerIsSelected: String = "포기할래요"
  }
  
  enum RestingViewState {
    static let targetLabel: String = "휴식시간"
    static let setTimerButton: String = "휴식시간 설정"
    static let setTimerIsSelected: String = "그만 쉴래요"
  }
  
  enum TargetLabel {
    static func updated(_ minutes: String) -> String {
      "집중시간 \(minutes)분"
    }
  }
  
  enum TimeLabel {
    static let defaultText: String = "00:00"
  }
}

extension TimerSceneViewController.Constant.Layout {
  enum TimerProgressView {
    static let innerPadding: CGFloat = 16
    static let bottomPadding: CGFloat = 55
    static let width: CGFloat = 236
    static let height: CGFloat = 236
    static let lineWidth: CGFloat = 9
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
