import Foundation

@MainActor
public protocol TimerSceneWorkable: Sendable {
  var countDownSequence: @Sendable (Double) -> CountDownSequence { get set }
}
