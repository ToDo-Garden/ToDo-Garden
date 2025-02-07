import Foundation

extension Cache {
  final class Storage: IterableCache<String, CacheItem<RequestState>>, NSCacheDelegate {
    var removedContinuations: [String: [Continuation]] = [:]
    
    override init(totalCostLimit: Int) {
      super.init(totalCostLimit: totalCostLimit)
      self.cache.delegate = self
    }
    
    override func removeObject(forKey key: String) {
      super.removeObject(forKey: key)
      self.lock.withLock {
        self.removedContinuations[key] = nil
      }
    }
    
    override func removeAllObjects() {
      for key in keys {
        self.object(forKey: key)?.loadingState?.task.cancel()
      }
      for continuations in self.removedContinuations {
        for continutaion in continuations.value {
          continutaion.resume(throwing: CancellationError())
        }
      }
      super.removeAllObjects()
    }
    
    func setRequestState(
      _ value: RequestState,
      forKey key: String,
      cost: Int = 0
    ) {
      let cacheItem = CacheItem<RequestState>(
        key: key,
        value: value,
        expiration: ExpirationLocals.value
      )
      super.setObject(cacheItem, forKey: key, cost: cost)
    }
    
    func continuations(forKey key: String) -> [Continuation] {
      self.lock.withLock {
        self.object(forKey: key)?.loadingState?.continuations
        ?? removedContinuations[key]
        ?? []
      }
    }
    
    // MARK: - NSCacheDelegate
    /// loading 상태에서 캐시 정책에 의해서 제거될 경우, 값을 저장해서 전파하기 위해서.
    func cache(
      _ cache: NSCache<AnyObject, AnyObject>,
      willEvictObject obj: Any
    ) {
      guard let item = obj as? CacheItem<RequestState> else {
        return
      }
      let key = item.key
      switch item.boxedValue {
      case RequestState.response:
        self.removedContinuations[key] = nil
        self.keys.remove(key)
      case RequestState.loading(let state):
        self.removedContinuations[key] = state.continuations
      }
    }
  }
}

enum ExpirationLocals {
  @TaskLocal static var value: StorageExpiration = .expired
}

@dynamicMemberLookup
final class CacheItem<Value> {
  let key: String
  private var value: Value
  let expiration: StorageExpiration
  
  var boxedValue: Value {
    _read { yield self.value }
    _modify { yield &self.value }
  }
  
  var isExpired: Bool {
    Date().timeIntervalSince(self.estimatedExpiration) <= 0
  }
  private(set) var estimatedExpiration: Date
  
  init(
    key: String,
    value: Value,
    expiration: StorageExpiration
  ) {
    self.key = key
    self.value = value
    self.expiration = expiration
    self.estimatedExpiration = expiration.estimatedExpirationSinceNow
  }
  
  func extendExpiration(_ extendingExpiration: ExpirationExtending = .cacheTime) {
    switch extendingExpiration {
    case ExpirationExtending.none: break
    case ExpirationExtending.cacheTime:
      estimatedExpiration = expiration.estimatedExpirationSinceNow
    case ExpirationExtending.expirationTime(let expiration):
      estimatedExpiration = expiration.estimatedExpirationSinceNow
    }
  }
  
  public subscript<Member>(dynamicMember keyPath: WritableKeyPath<Value, Member>) -> Member {
    get { self.boxedValue[keyPath: keyPath] }
    set { self.boxedValue[keyPath: keyPath] = newValue }
  }
}
