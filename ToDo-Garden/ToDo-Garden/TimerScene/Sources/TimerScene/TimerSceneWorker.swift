import CombineExtension
import Foundation

public struct TimerSceneWorker: TimerSceneWorkable, Sendable {
  public var countDownStream: @Sendable (Double) -> AsyncStream<Double>
  public init(
    countDownStream: @Sendable @escaping (Double) -> AsyncStream<Double>
  ) {
    self.countDownStream = countDownStream
  }
}

extension TimerSceneWorker {
  static let live = Self { seconds in
    return Timer
      .publish(every: 1, on: RunLoop.main, in: RunLoop.Mode.common)
      .autoconnect()
      .scan(seconds) { value, _ in
        max(value - 1, 0)
      }
      .prefix(while: { $0 > 0 })
      .append(0)
      .eraseToAnyPublisher()
      .asyncStream
  }
}
