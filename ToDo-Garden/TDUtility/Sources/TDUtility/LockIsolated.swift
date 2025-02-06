import Foundation

@dynamicMemberLookup
public final class LockIsolated<Value>: @unchecked Sendable {
  private var _value: Value
  private let lock = NSRecursiveLock()
  
  public init(_ value: Value) {
    self._value = value
  }
  
  public subscript<Subject: Sendable>(dynamicMember keyPath: KeyPath<Value, Subject>) -> Subject {
    self.lock.sync {
      self._value[keyPath: keyPath]
    }
  }
  
  public func withValue<T: Sendable>(
    _ operation: @Sendable (inout Value) throws -> T
  ) rethrows -> T {
    try self.lock.sync {
      var value = self._value
      defer { self._value = value }
      return try operation(&value)
    }
  }
  
  public func setValue(
    _ newValue: @autoclosure @Sendable () throws -> Value
  ) rethrows {
    try self.lock.sync {
      self._value = try newValue()
    }
  }
}

extension LockIsolated where Value: Sendable {
  public var value: Value {
    lock.sync {
      self._value
    }
  }
}

extension NSRecursiveLock {
  @inlinable @discardableResult
  @_spi(Internals) public func sync<R>(work: () throws -> R) rethrows -> R {
    self.lock()
    defer { self.unlock() }
    return try work()
  }
}
