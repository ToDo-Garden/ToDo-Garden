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
    
    private var targetTime: TimeInterval
    private var timeCorrection: TimeInterval
    
    init(endTime: TimeInterval, timeInterval: UInt64) {
      self.endTime = endTime
      self.timeInterval = timeInterval
      self.targetTime = Date().timeIntervalSince1970
      self.timeCorrection = 0
    }
    
    public mutating func next() async throws -> Double? {
      guard self.endTime > 0 else { return nil }
      self.targetTime += 1.0
      try await self.sleepForCorrectTime()
      self.endTime -= 1.0
      
      return self.endTime
    }
    
    private mutating func sleepForCorrectTime() async throws {
      let current = Date().timeIntervalSince1970
      let sleepTime = self.targetTime - current + self.timeCorrection
      if sleepTime > 0 {
        try await Task.sleep(nanoseconds: UInt64(sleepTime * Double(self.timeInterval)))
        self.timeCorrection = 0
      } else {
        try Task.checkCancellation()
        self.timeCorrection = sleepTime
      }
    }
  }
}
