import Foundation

@MainActor
public protocol TimerSceneWorkable: Sendable {
  var countDownStream: @Sendable (Double) -> AsyncThrowingStream<Double, any Error> { get set }
}
