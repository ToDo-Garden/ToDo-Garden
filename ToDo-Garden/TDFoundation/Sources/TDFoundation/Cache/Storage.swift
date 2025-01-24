import Foundation

public enum StorageExpiration: Sendable {
  var estimatedExpirationSinceNow: Date {
    switch self {
    case .never: return .distantFuture
    case .seconds(let seconds): return Date().addingTimeInterval(seconds)
    case .expired: return .distantPast
    }
  }
  
  var isExpired: Bool {
    timeInterval <= 0
  }
  
  var timeInterval: TimeInterval {
    switch self {
    case .never: return .infinity
    case .seconds(let seconds): return seconds
    case .expired: return -.infinity
    }
  }
  
  case never
  case seconds(TimeInterval)
  case expired
}

public enum ExpirationExtending: Sendable {
  case none
  case cacheTime
  case expirationTime(expiration: StorageExpiration)
}
