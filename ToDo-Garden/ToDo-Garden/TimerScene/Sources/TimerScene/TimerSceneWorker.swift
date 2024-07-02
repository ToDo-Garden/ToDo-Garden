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
    AsyncIterator(endTime: endTime, timeInterval: timeInterval)
  }
  public struct AsyncIterator: AsyncIteratorProtocol {
    private var endTime: TimeInterval
    private let timeInterval: UInt64
    private var isFirst: Bool = true
    
    init(
      endTime: TimeInterval,
      timeInterval: UInt64
    ) {
      self.endTime = endTime
      self.timeInterval = timeInterval
    }
    
    public mutating func next() async throws -> Double? {
      guard self.endTime > 0 else { return nil }
      try await Task.sleep(nanoseconds: timeInterval)
      self.endTime -= 1
      return self.endTime
    }
  }
}
