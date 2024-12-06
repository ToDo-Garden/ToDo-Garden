import Foundation

public enum KeyConstants {
  static let storage: LockIsolated<[String: String]> = {
    guard
      let url = Bundle.main.url(forResource: ".env", withExtension: nil)
    else {
      debugPrint("❌ Error: Could not locate .env in the app bundle.")
      return LockIsolated([:])
    }
    let envData: @Sendable (URL) -> [String: String] = { url in
      var dict: [String: String] = [:]
      do {
        let data = try String(contentsOf: url, encoding: .utf8)
        let lines = data.split(separator: "\n")
        
        for line in lines {
          let parts = line
            .split(separator: "=", maxSplits: 1)
            .map(String.init)
          if parts.count == 2 {
            let key = parts[0]
              .trimmingCharacters(in: .whitespaces)
            let value = parts[1]
              .trimmingCharacters(in: .whitespacesAndNewlines)
              .replacingOccurrences(of: "\"", with: "")
            dict[key] = value
          }
        }
        debugPrint("✅ Success: .env loaded and decoded successfully.")
      } catch {
        debugPrint("❌ Error: Failed to load .env - \(error.localizedDescription)")
      }
      
      return dict
    }
    
    return LockIsolated(envData(url))
  }()
}

@dynamicMemberLookup
final class LockIsolated<Value>: @unchecked Sendable {
  private var _value: Value
  private let lock = NSRecursiveLock()
  
  init(_ value: Value) {
    self._value = value
  }
  
  public subscript<Subject: Sendable>(dynamicMember keyPath: KeyPath<Value, Subject>) -> Subject {
    self.lock.sync {
      self._value[keyPath: keyPath]
    }
  }
}

extension LockIsolated where Value: Sendable {
  var value: Value {
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
