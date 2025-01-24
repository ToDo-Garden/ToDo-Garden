import Foundation

extension Cache {
  final class Storage<Value: AnyObject>: NSObject, NSCacheDelegate {
    let cache = NSCache<NSString, Value>()
    var keys = Set<String>()
    var removedContinuations: [String: [Continuation]] = [:]
    
    init(totoalCostLimit: Int) {
      self.cache.totalCostLimit = totoalCostLimit
      super.init()
      self.cache.delegate = self
    }
    
    func object(forKey key: String) -> Value? {
      self.cache.object(forKey: key as NSString)
    }
    
    func setObject(_ obj: Value, forKey key: String, cost: Int = 0) {
      self.cache.setObject(obj, forKey: key as NSString, cost: cost)
      self.keys.insert(key)
    }
    
    func removeObject(forKey key: String) {
      self.cache.removeObject(forKey: key as NSString)
      self.keys.remove(key)
    }
    
    func removeAllObjects() {
      self.cache.removeAllObjects()
      self.keys.removeAll()
    }
    
    func cache(
      _ cache: NSCache<AnyObject, AnyObject>,
      willEvictObject obj: Any
    ) {
      guard
        let box = obj as? Box<RequestState>,
        let loadingState = box.loadingState
      else { return }
      self.removedContinuations[box.key] = loadingState.continuations
      self.keys.remove(box.key)
    }
  }
}

extension Cache.Storage: Sequence {
  func makeIterator() -> AnyIterator<(String, Value)> {
    var iterator = self.keys.makeIterator()
    return AnyIterator {
      while let key = iterator.next() {
        if let value = self.cache.object(forKey: key as NSString) {
          return (key, value)
        }
      }
      return nil
    }
  }
}

