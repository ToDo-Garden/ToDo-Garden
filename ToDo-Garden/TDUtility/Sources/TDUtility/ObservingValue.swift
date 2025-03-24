import Foundation.NSLock

public final class ObservingValue<T: Equatable & Hashable>: @unchecked Sendable {
  private var lock = NSLock()
  private var listener: ((T) -> Void)?
  
  public var value: T {
    didSet {
      self.lock.lock()
      defer { self.lock.unlock() }
      self.listener?(value)
    }
  }
  
  public init(_ value: T) {
    self.value = value
  }
  
  public func bind(_ listener: @escaping (T) -> Void) {
    self.lock.lock()
    defer { self.lock.unlock() }
    self.listener = listener
    listener(self.value)
  }
}

extension ObservingValue: Equatable {
  public static func == (lhs: ObservingValue<T>, rhs: ObservingValue<T>) -> Bool {
    return lhs.value == rhs.value
  }
}

extension ObservingValue: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.value)
  }
}
