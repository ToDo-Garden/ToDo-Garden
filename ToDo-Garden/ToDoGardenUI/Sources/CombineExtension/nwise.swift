#if canImport(Combine)
import Combine

public extension Publisher {
  func nwise(_ size: Int) -> AnyPublisher<[Output], Failure> {
    assert(size > 1, "n must be greater than 1")
    
    return self.scan([]) { acc, item in Array((acc + [item]).suffix(size)) }
      .filter { $0.count == size }
      .eraseToAnyPublisher()
  }
  
  func pairwise() -> AnyPublisher<(Output, Output), Failure> {
    nwise(2)
      .map { ($0[0], $0[1]) }
      .eraseToAnyPublisher()
  }
}
#endif
