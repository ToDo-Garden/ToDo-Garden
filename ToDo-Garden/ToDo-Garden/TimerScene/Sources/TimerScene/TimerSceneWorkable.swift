import Foundation

@MainActor
public protocol TimerSceneWorkable: Sendable {
  var countDownSequence: @Sendable (Double) -> AsyncThrowingStream<Double, any Error> { get set }
}
