import Foundation

enum Expiration {
  @TaskLocal static var value: StorageExpiration = .expired
}

extension Cache {
  class Storage: IterableCache<String, CacheItem<RequestState>>, NSCacheDelegate {
    private(set) var removedContinuations: [String: [Continuation]] = [:]
    
    override init(totalCostLimit: Int) {
      super.init(totalCostLimit: totalCostLimit)
      self.cache.delegate = self
    }
    
    override func removeObject(forKey key: String) {
      super.removeObject(forKey: key)
      self.removedContinuations[key] = nil
    }
    
    func setRequestState(
      _ value: RequestState,
      forKey key: String,
      cost: Int = 0
    ) {
      let cacheItem = CacheItem<RequestState>(
        key: key,
        value: value,
        expiration: Expiration.value
      )
      super.setObject(cacheItem, forKey: key, cost: cost)
    }
    
    func continuations(forKey key: String) -> [Continuation] {
      self.lock.lock()
      defer { self.lock.unlock() }
      return self.object(forKey: key)?.value.loadingState?.continuations
      ?? self.removedContinuations[key]
      ?? []
    }
    
    // MARK: - NSCacheDelegate Protocol
    /// loading 상태에서 캐시 정책에 의해서 제거될 경우, 값을 저장해서 전파하기 위해서.
    func cache(
      _ cache: NSCache<AnyObject, AnyObject>,
      willEvictObject obj: Any
    ) {
      guard let item = obj as? CacheItem<RequestState> else { return }
      let key = item.key
      switch item.value {
      case .response:
        self.removedContinuations[key] = nil
        self.keys.remove(key)
      case .loading(let state):
        self.removedContinuations[item.key] = state.continuations
      }
    }
  }
}

@dynamicMemberLookup
final class CacheItem<Value> {
  let key: String
  var value: Value
  let expiration: StorageExpiration
  
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
    case .none: break
    case .cacheTime:
      self.estimatedExpiration = self.expiration.estimatedExpirationSinceNow
    case .expirationTime(let expiration):
      self.estimatedExpiration = expiration.estimatedExpirationSinceNow
    }
  }
  
  public subscript<Member>(dynamicMember keyPath: KeyPath<Value, Member>) -> Member {
    self.value[keyPath: keyPath]
  }
}
