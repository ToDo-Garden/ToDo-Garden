import Foundation

public struct TimerSceneWorker: TimerSceneWorkable, Sendable {
  public var countDownSequence: @Sendable (Double) -> CountDownSequence
  
  public init(
    countDownSequence: @Sendable @escaping (Double) -> CountDownSequence
  ) {
    self.countDownSequence = countDownSequence
  }
}

extension TimerSceneWorker {
  static let live = Self { seconds in
    return CountDownSequence(endTime: seconds)
  }
}

public struct CountDownSequence: AsyncSequence {
  public typealias Element = Double
  let endTime: TimeInterval
  let timeInterval: UInt64
  
  init(endTime: TimeInterval, timeInterval: UInt64 = 1_000_000_000) {
    self.endTime = endTime
    self.timeInterval = timeInterval
  }
  
  public func makeAsyncIterator() -> AsyncIterator {
    AsyncIterator(endTime: endTime, initTime: endTime, timeInterval: timeInterval)
  }
  public struct AsyncIterator: AsyncIteratorProtocol {
    var endTime: TimeInterval
    let initTime: TimeInterval
    let timeInterval: UInt64
    var isFirst: Bool = true
    
    public mutating func next() async throws -> Double? {
      guard self.endTime > 0 else { return nil }
      if self.isFirst {
        self.isFirst = false
        return self.endTime
      } else {
        try await Task.sleep(nanoseconds: timeInterval)
        self.endTime -= 1
        return self.endTime
      }
    }
  }
}
