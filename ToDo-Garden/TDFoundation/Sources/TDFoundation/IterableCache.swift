import Foundation

// swiftlint:disable identifier_name
public class IterableCache<Key: Hashable, Value: AnyObject>: NSObject {
  let cache = NSCache<Ref<Key>, Value>()
  var keys = Set<Key>()
  let lock = NSLock()
  
  public init(totalCostLimit: Int) {
    cache.totalCostLimit = totalCostLimit
  }
  
  public func setObject(_ obj: Value, forKey key: Key, cost g: Int = 0) {
    let ref = Ref(key)
    lock.work {
      cache.setObject(obj, forKey: ref, cost: g)
      keys.insert(key)
    }
  }
  
  public func object(forKey key: Key) -> Value? {
    cache.object(forKey: Ref(key))
  }
  
  public func removeObject(forKey key: Key) {
    lock.work {
      cache.removeObject(forKey: Ref(key))
      keys.remove(key)
    }
  }
  
  public func removeAllObjects() {
    lock.work {
      cache.removeAllObjects()
      keys.removeAll()
    }
  }
}

// MARK: - Sequence Protocol
extension IterableCache: Sequence {
  public func makeIterator() -> AnyIterator<(Key, Value)> {
    var iterator = keys.makeIterator()
    return AnyIterator {
      while let key = iterator.next() {
        if let value = self.cache.object(forKey: Ref(key)) {
          return (key, value)
        }
      }
      
      return nil
    }
  }
}

extension IterableCache {
  final class Ref<T: Hashable>: NSObject {
    override var hash: Int {
      key.hashValue
    }
    let key: T
    
    init(_ key: T) {
      self.key = key
    }
    
    override func isEqual(_ object: Any?) -> Bool {
      guard let other = object as? Ref<T> else {
        return false
      }
      return key == other.key
    }
  }
}

private extension NSLock {
  func work(_ work: () -> Void) {
    lock()
    defer { unlock() }
    work()
  }
}
// swiftlint:enable identifier_name
