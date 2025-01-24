import Foundation
import UIKit.UIApplication

import class TDUtility.LockIsolated

// swiftlint:disable function_body_length
public final class Cache<Request: Requestable>: Sendable {
  let request: Request
  let configuration: Configuration
  
  let storage: LockIsolated<Storage<Box<RequestState>>>
  private let memoryWarningTask = LockIsolated<Task<Void, Never>?>(nil)
  private let expireTask = LockIsolated<Task<Void, Never>?>(nil)
  
  public init(
    request: Request,
    configuration: Configuration = Configuration()
  ) {
    self.request = request
    self.configuration = configuration
    self.storage = .init(.init(totoalCostLimit: configuration.limit.cost))
    
    self.memoryWarningTask.setValue(buildMemoryWarningTask())
    self.expireTask.setValue(buildExpireTask())
  }
  
  private func buildMemoryWarningTask() -> Task<Void, Never> {
    Task {
      let stream = NotificationCenter.default
        .publisher(for: UIApplication.didReceiveMemoryWarningNotification)
        .values
      for await _ in stream {
        storage.withValue {
          $0.removeAllObjects()
        }
      }
    }
  }
  
  private func buildExpireTask() -> Task<Void, Never> {
    Task {
      let stream = Timer
        .publish(
          every: configuration.cleanupInterval,
          on: .main,
          in: .common
        )
        .autoconnect()
        .values
      for await _ in stream {
        self.removeExpired()
      }
    }
  }
  
  private func removeExpired() {
    storage.withValue { cache in
      for (key, box) in cache where box.isExpired {
        box.loadingState?.task.cancel()
        cache.removeObject(forKey: key)
      }
    }
  }
  
  public func execute(
    _ id: Request.ID,
    expiration: StorageExpiration? = nil
  ) async throws -> Request.Response {
    try await withTaskCancellationHandler {
      try await withCheckedThrowingContinuation { continuation in
        storage.withValue { cache in
          let key = id.description
          let box = cache.object(forKey: key)
          
          switch box?.value {
          case .response(let response):
            continuation.resume(returning: response)
            
          case .loading(var state):
            if Task.isCancelled {
              continuation.resume(throwing: CancellationError())
              state.task.cancel()
              return
            }
            state.continuations.append(continuation)
            box?.value.loadingState = state
            
          case .none:
            if Task.isCancelled {
              continuation.resume(throwing: CancellationError())
              return
            }
            let expiration = expiration ?? configuration.expiration
            let task = buildTask(id, expiration: expiration)
            let box = Box<RequestState>(
              key: key,
              value: .loading(.init(task: task, continuations: [continuation])),
              expiration: expiration
            )
            cache.setObject(box, forKey: key)
          }
          
          if let box, !box.isExpired {
            box.extendExpiration()
          }
        }
      }
    } onCancel: {
      let task = storage.withValue { cache in
        cache.object(forKey: id.description)?.loadingState?.task
      }
      task?.cancel()
    }
  }
  
  private func buildTask(
    _ id: Request.ID,
    expiration: StorageExpiration
  ) -> Task<Void, Never> {
    Task {
      do {
        let response = try await self.request.execute(id: id)
        let continuations: [Continuation] = try storage.withValue { cache  in
          let key = id.description
          guard
            let loadingState = cache.object(forKey: key)?.loadingState
          else { return [] }
          let box = Box<RequestState>(
            key: key,
            value: .response(response),
            expiration: expiration
          )
          cache.setObject(
            box,
            forKey: key,
            cost: try response.estimatedMemory.cost
          )
          
          return loadingState.continuations
        }
        
        try Task.checkCancellation()
        for continuation in continuations {
          continuation.resume(returning: response)
          await Task.yield()
        }
      } catch {
        self.cancel(for: id, error: error)
      }
    }
  }
  
  public func cancel(for id: Request.ID, error: any Error) {
    let continuations: [Continuation] = self.storage.withValue { cache in
      let key = id.description
      let continuations = cache
        .object(forKey: key)?
        .loadingState?
        .continuations
      ?? cache.removedContinuations[key]
      ?? []
      
      cache.removeObject(forKey: key)
      cache.removedContinuations[key] = nil
      
      return continuations
    }
    
    Task {
      for continuation in continuations {
        continuation.resume(throwing: error)
        await Task.yield()
      }
    }
  }
}

extension Cache {
  public struct Configuration: Sendable {
    let limit: Measurement<UnitInformationStorage>
    let expiration: StorageExpiration
    let cleanupInterval: TimeInterval
    
    public init(
      limit: Measurement<UnitInformationStorage> = .memoryLimit,
      expiration: StorageExpiration = .seconds(300),
      cleanupInterval: TimeInterval = 120
    ) {
      self.limit = limit
      self.expiration = expiration
      self.cleanupInterval = cleanupInterval
    }
  }
  
  typealias Continuation = CheckedContinuation<Request.Response, any Error>
  enum RequestState: Sendable {
    case response(Request.Response)
    
    struct LoadingState: Sendable {
      let task: Task<Void, Never>
      var continuations: [Continuation]
    }
    var loadingState: LoadingState? {
      get {
        guard case .loading(let state) = self else { return nil }
        return state
      }
      set {
        guard let newValue else { return }
        self = .loading(newValue)
      }
    }
    case loading(LoadingState)
  }
}

extension Cache.RequestState: MemorySizeProvider {
  var estimatedMemory: Measurement<UnitInformationStorage> {
    get throws {
      switch self {
      case Cache.RequestState.response(let response):
        return try response.estimatedMemory
        
        // TODO: 배열 자체도 크기를 갖기 때문에 추후에 수정하면 좋을 거 같음.
      case Cache.RequestState.loading:
        return Measurement(value: .zero, unit: .bytes)
      }
    }
  }
}

extension Cache {
  @dynamicMemberLookup
  final class Box<Value> {
    let key: String
    var value: Value
    let expiration: StorageExpiration
    private(set) var estimatedExpiration: Date
    
    var isExpired: Bool {
      Date().timeIntervalSince(estimatedExpiration) <= 0
    }
    
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
}
// swiftlint:enable function_body_length
