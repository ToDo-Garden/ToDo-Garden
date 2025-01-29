import Foundation
import UIKit.UIApplication

import TDUtility

// swiftlint:disable function_body_length
public final class Cache<Request: Requestable>: Sendable {
  let request: Request
  let configuration: Configuration
  
  let storage: LockIsolated<Storage>
  
  private let memoryWarningTask = LockIsolated<Task<Void, Never>?>(nil)
  private let expireTask = LockIsolated<Task<Void, Never>?>(nil)
  
  public init(
    request: Request,
    configuration: Configuration = Configuration()
  ) {
    self.request = request
    self.configuration = configuration
    self.storage = LockIsolated(Storage(totalCostLimit: configuration.limit.cost))
    self.memoryWarningTask.setValue(self.buildMemoryWarningTask())
    self.expireTask.setValue(self.buildExpireTask())
  }
  
  private func buildMemoryWarningTask() -> Task<Void, Never> {
    Task {
      let stream = NotificationCenter.default
        .publisher(for: UIApplication.didReceiveMemoryWarningNotification)
        .values
      for await _ in stream {
        storage.withValue { cache in
          cache.removeAllObjects()
        }
      }
    }
  }
  
  private func buildExpireTask() -> Task<Void, Never> {
    Task {
      let stream = Timer
        .publish(
          every: self.configuration.cleanupInterval,
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
    self.storage.withValue { cache in
      for (key, item) in cache where item.isExpired {
        item.loadingState?.task.cancel()
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
        self.storage.withValue { cache in
          let expiration = expiration ?? self.configuration.expiration
          Expiration.$value.withValue(expiration) {
            let key = id.description
            let item = cache.object(forKey: key)
            
            switch item?.value {
            case RequestState.response(let response)?:
              continuation.resume(returning: response)
              
            case RequestState.loading(var state)?:
              if Task.isCancelled {
                continuation.resume(throwing: CancellationError())
                state.task.cancel()
                return
              }
              state.continuations.append(continuation)
              item?.value.loadingState = state
              
            case .none:
              if Task.isCancelled {
                continuation.resume(throwing: CancellationError())
                return
              }
              let task = self.buildTask(id)
              cache.setRequestState(
                RequestState.loading(
                  RequestState.LoadingState(task: task, continuations: [continuation])
                ),
                forKey: key
              )
            }
            
            if let item, !item.isExpired {
              item.extendExpiration()
            }
          }
        }
        
      }
    } onCancel: {
      let task = self.storage.withValue { cache in
        cache.object(forKey: id.description)?.loadingState?.task
      }
      task?.cancel()
    }
  }
  
  private func buildTask(_ id: Request.ID) -> Task<Void, Never> {
    Task {
      do {
        let response = try await self.request.execute(id: id)
        let continuations: [Continuation] = try self.storage.withValue { cache  in
          let key = id.description
          let continuations = cache.continuations(forKey: key)
          cache.removeObject(forKey: key)
          cache.setRequestState(
            RequestState.response(response),
            forKey: key,
            cost: try response.estimatedMemory.cost
          )
          
          return continuations
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
      let continuations = cache.continuations(forKey: id.description)
      cache.removeObject(forKey: id.description)
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
        guard case RequestState.loading(let state) = self else { return nil }
        return state
      }
      set {
        guard let newValue else { return }
        self = RequestState.loading(newValue)
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
        
        /// 배열의 가변적인 크기를 NSCache cost 방식하고 어울리지 않음.
      case Cache.RequestState.loading:
        return Measurement(value: 0, unit: .bytes)
      }
    }
  }
}
// swiftlint:enable function_body_length
