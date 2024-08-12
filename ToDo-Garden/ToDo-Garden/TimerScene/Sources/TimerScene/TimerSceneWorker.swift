import Foundation

public struct TimerSceneWorker: TimerSceneWorkable, Sendable {
  public var countDownStream: @Sendable (Double) -> AsyncStream<Double>
  public init(
    countDownStream: @Sendable @escaping (Double) -> AsyncStream<Double>
  ) {
    self.countDownStream = countDownStream
  }
}

@preconcurrency import Combine

public extension Publisher where Output: Sendable {
  var stream: AsyncStream<Output> {
    AsyncStream<Output> { continuation in
      let cancellable = self.sink { _ in
        continuation.finish()
      } receiveValue: { value in
        continuation.yield(value)
      }
      
      continuation.onTermination = { _ in
        cancellable.cancel()
      }
    }
  }
}

extension TimerSceneWorker {
  static let live = Self { seconds in
    return Timer
      .publish(every: 1, on: .main, in: .common)
      .autoconnect()
      .scan(seconds) { value, _ in
        max(value - 1, 0)
      }
      .prefix(while: { $0 > 0 })
      .append(0)
      .eraseToAnyPublisher()
      .stream
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
    ///
    ///   endTime: CountDownSequnce의 생성자를 통해 초기화 되는 값
    ///   ex: 10초 카운트 시퀀스의 경우 endTime이 10으로 초기화 된다.
    private var endTime: TimeInterval
    private let timeInterval: UInt64
    ///
    ///   targetTime: AsyncIterator가 초기화 될 때 생성되며, 값이 방출될 때 마다( == next 함수가 호출될 때 마다)
    ///   1초씩 증가함으로 써 보정 값하고 비교할 수 있는 수치.
    private var targetTime: TimeInterval
    ///
    ///   timeCorrection: sleepForCorrectTime 함수 내부에 sleepTime이 음수가 발생할 경우를 대비해서 만든 값
    ///   다음 주기의 시간 값까지 초과 시킨 경우 sleepTime이 음수가 나옵니다.
    private var timeCorrection: TimeInterval
    private var isFirst: Bool = true
    
    init(endTime: TimeInterval, timeInterval: UInt64) {
      self.endTime = endTime
      self.timeInterval = timeInterval
      self.targetTime = Date().timeIntervalSince1970
      self.timeCorrection = 0
    }
    
    public mutating func next() async throws -> Double? {
      guard self.endTime > 0 else { return nil }
      if self.isFirst {
        self.isFirst = false
      } else {
        self.targetTime += 1.0
        try await self.sleepForCorrectTime()
        self.endTime -= 1.0
      }
      
      return self.endTime
    }
    
    private mutating func sleepForCorrectTime() async throws {
      let current = Date().timeIntervalSince1970
      let sleepTime = self.targetTime - current + self.timeCorrection
      if sleepTime > 0 {
        let nanoseconds = UInt64(sleepTime * Double(self.timeInterval))
        try await Task.sleep(nanoseconds: nanoseconds)
        self.resetTimeCorrenction()
      } else {
        try Task.checkCancellation()
        self.timeCorrection = sleepTime
      }
    }
    
    private mutating func resetTimeCorrenction() {
      self.timeCorrection = 0
    }
  }
}
