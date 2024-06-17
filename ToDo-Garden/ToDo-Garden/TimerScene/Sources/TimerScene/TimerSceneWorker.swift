import Foundation

public struct TimerSceneWorker: TimerSceneWorkable, Sendable {
  let timerClient: TimerClient
  
  public init(timerClient: TimerClient = .live) {
    self.timerClient = timerClient
  }
  
  public func countdownStream(_ endTime: Date) -> CountDownSequence {
    timerClient.stream(endTime)
  }
}

public struct TimerClient: Sendable {
  private let _dateToTimeInterval: @Sendable (Date) -> TimeInterval
  
  public func stream(_ endTime: Date) -> CountDownSequence {
    let endTime = _dateToTimeInterval(endTime)
    return CountDownSequence(endTime: endTime)
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
    AsyncIterator(endTime: endTime, initTime: endTime, timeInterval: timeInterval)
  }
  public struct AsyncIterator: AsyncIteratorProtocol {
    var endTime: TimeInterval
    let initTime: TimeInterval
    let timeInterval: UInt64
    var isFirst: Bool = true
    
    public mutating func next() async throws -> Double? {
      guard endTime > 0 else { return nil }
      if isFirst {
        isFirst = false
        return endTime
      } else {
        try await Task.sleep(nanoseconds: timeInterval)
        endTime -= 1
        return endTime
      }    }
  }
}

public extension TimerClient {
  static let live: Self = .init { date in
    let calendar = Calendar.current
    let dateComponents = calendar
      .dateComponents([Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second], from: date)
    let hour = (dateComponents.hour ?? 0) * 60 * 60
    let minutes = (dateComponents.minute ?? 0) * 60
    let seconds = dateComponents.second ?? 0
    
    return TimeInterval(hour + minutes + seconds)
  }
}
