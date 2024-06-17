import Foundation

@MainActor
public protocol TimerSceneWorkable: Sendable {
  func countdownStream(_ endTime: Date) -> CountDownSequence
}
