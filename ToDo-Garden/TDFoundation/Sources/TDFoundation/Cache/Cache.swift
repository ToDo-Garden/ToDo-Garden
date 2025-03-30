import Foundation
import UIKit.UIApplication

// swiftlint:disable function_body_length
public final actor Cache<Request: Requestable>: Sendable {
  let request: Request
  let configuration: Configuration
  let storage: Storage
  private var memoryWarningTask: Task<Void, Never>?
  private var cleanupTask: Task<Void, Never>?
  
  public init(
    request: Request,
    configuration: Configuration = Configuration(),
    dependency: Dependecny = Dependecny.liveValue
  ) {
    self.request = request
    self.configuration = configuration
    self.storage = Storage(totalCostLimit: configuration.limit.cost)
    
    Task {
      await self.prepare(dependency: dependency)
    }
  }
  
  private func prepare(dependency: Dependecny) {
    self.memoryWarningTask = Task { [weak self] in
      let stream = dependency
        .memoryWarningStream()
        .values
      for await _ in stream {
        guard let self, !Task.isCancelled else {
          break
        }
        await self.removeAllObjects()
      }
    }
    
    let cleanupInterval = self.configuration.cleanupInterval
    self.cleanupTask = Task { [weak self] in
      let stream = dependency
        .cleanupTimerStream(cleanupInterval)
        .values
      for await _ in stream {
        guard let self, !Task.isCancelled else {
          break
        }
        await self.removeExpiredCacheItem()
      }
    }
  }
  
  private func removeAllObjects() {
    self.storage.removeAllObjects()
  }
  
  private func removeExpiredCacheItem() {
    for (key, item) in self.storage where item.isExpired {
      if let loadingState = item.loadingState {
        loadingState.task.cancel()
      } else {
        self.storage.removeObject(forKey: key)
      }
    }
  }
  
  deinit {
    self.memoryWarningTask?.cancel()
    self.cleanupTask?.cancel()
  }
  
  public func execute(
    id: Request.ID,
    expiration: StorageExpiration? = nil
  ) async throws -> Request.Response {
    let task = self.storage.object(forKey: id.description)?.loadingState?.task
    guard !Task.isCancelled else {
      task?.cancel()
      throw CancellationError()
    }
    
    return try await withTaskCancellationHandler {
      try await withCheckedThrowingContinuation { continuation in
        let item = self.storage.object(forKey: id.description)
        switch item?.boxedValue {
        case RequestState.response(let response)?:
          continuation.resume(returning: response)
          
        case RequestState.loading?:
          item?.loadingState?.continuations.append(continuation)
          
        case nil:
          ExpirationLocals.$value.withValue(expiration ?? configuration.expiration) {
            self.storage.setRequestState(
              .loading(.init(task: initialTask(id), continuations: [continuation])),
              forKey: id.description
            )
          }
        }
        
        if let item, !item.isExpired {
          item.extendExpiration()
        }
      }
    } onCancel: {
      task?.cancel()
    }
  }
  
  private func initialTask(_ id: Request.ID) -> Task<Void, Never> {
    Task {
      do {
        let response = try await self.request.execute(id: id, isDownsample: false)
        try Task.checkCancellation()
        let key = id.description
        let continuations = self.storage.continuations(forKey: key)
        self.storage.removeObject(forKey: key)
        self.storage.setRequestState(
          RequestState.response(response),
          forKey: key,
          cost: try response.estimatedMemory.cost
        )
        
        for continuation in continuations {
          continuation.resume(returning: response)
          await Task.yield()
        }
      } catch {
        self._cancel(for: id, error: error)
      }
    }
  }
  
  public nonisolated func cancel(id: Request.ID) {
    Task {
      await self._cancel(for: id)
    }
  }
  
  private func _cancel(for id: Request.ID, error: any Error = CancellationError()) {
    let continuations = self.storage.continuations(forKey: id.description)
    self.storage.removeObject(forKey: id.description)
    Task {
      for continuation in continuations {
        continuation.resume(throwing: error)
        await Task.yield()
      }
    }
  }
  
  public func isCached(id: Request.ID) -> Bool {
    self.storage.contains(forKey: id.description)
  }
}

import Combine

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
  enum RequestState {
    case response(Request.Response)
    
    struct LoadingState: Sendable {
      let task: Task<Void, Never>
      var continuations: [Continuation]
    }
    var loadingState: LoadingState? {
      get {
        guard case Self.loading(let state) = self else {
          return nil
        }
        return state
      }
      set {
        guard let newValue else {
          return
        }
        self = Self.loading(newValue)
      }
    }
    case loading(LoadingState)
  }
  
  public struct Dependecny: Sendable {
    public var memoryWarningStream: @Sendable () -> AnyPublisher<Void, Never>
    public var cleanupTimerStream: @Sendable (Double) -> AnyPublisher<Void, Never>
    
    public init(
      memoryWarningStream: @Sendable @escaping () -> AnyPublisher<Void, Never>,
      cleanupTimerStream: @Sendable @escaping (Double) -> AnyPublisher<Void, Never>
    ) {
      self.memoryWarningStream = memoryWarningStream
      self.cleanupTimerStream = cleanupTimerStream
    }
  }
}

extension Cache.Dependecny {
  public static var liveValue: Self {
    Self(
      memoryWarningStream: {
        NotificationCenter.default
          .publisher(for: UIApplication.didReceiveMemoryWarningNotification)
          .map { _ in () }
          .eraseToAnyPublisher()
      },
      cleanupTimerStream: {
        Timer
          .publish(every: $0, on: .main, in: .common)
          .autoconnect()
          .map { _ in () }
          .eraseToAnyPublisher()
      }
    )
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

extension Measurement where UnitType == UnitInformationStorage {
  var cost: Int {
    Int(converted(to: .bytes).value)
  }
}
// swiftlint:enable function_body_length
