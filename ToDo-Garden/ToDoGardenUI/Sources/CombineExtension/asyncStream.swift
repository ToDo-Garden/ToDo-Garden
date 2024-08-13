import Combine

extension Publisher where Output: Sendable {
  public var asyncStream: AsyncStream<Output> {
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
