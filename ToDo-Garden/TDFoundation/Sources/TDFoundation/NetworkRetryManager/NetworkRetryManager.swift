import Combine
import Foundation
import Network

import TDUtility

public final class NetworkRetryManager: NetworkRetryManagerAPI, @unchecked Sendable {
  private var tasks: [RetryTaskKey: Task<Void, Error>] = [:]
  private let retryInterval: TimeInterval
  private var cancellables = Set<AnyCancellable>()
  private let lock = NSLock()
  
  private let networkMonitor = NWPathMonitor()
  private let networkStatusSubject = CurrentValueSubject<Bool, Never>(false)
  public var retryTask: (@Sendable () async throws -> Void)?
  
  public init(retryInterval: TimeInterval = 120) {
    self.retryInterval = retryInterval
    self.setupNetworkMonitor()
  }
  
  private func setupNetworkMonitor() {
    let updateNetworkStatus = { @Sendable [weak self] in
      guard let isConnected = self?.checkConnectionStatus() else { return }
      self?.networkStatusSubject.send(isConnected)
    }
    
    self.networkMonitor.pathUpdateHandler = { _ in updateNetworkStatus() }
    updateNetworkStatus()
    self.networkStatusSubject
      .removeDuplicates()
      .pairwise()
      .filter { old, new in !old && new }
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _, _ in
        self?.startNetworkReconnectionObserver()
      }
      .store(in: &self.cancellables)
  }
  
  public func execute() {
    self.networkMonitor.start(queue: .global(qos: .background))
    self.startRetrying()
  }
  
  private func startRetrying() {
    Task { 
      self.startNetworkReconnectionObserver()
      self.startPeriodicRetry()
    }
  }
  
  private func startNetworkReconnectionObserver() {
    guard let retryTask = self.retryTask else { return }
    
    self.run(id: .networkReconnectionRetry) {
      guard self.checkConnectionStatus() else { return }
      try await retryTask()
    }
  }
  
  private func startPeriodicRetry() {
    guard let retryTask = self.retryTask else { return }

    self.run(id: .periodicRetry) {
      let timer = Timer.publish(
        every: self.retryInterval,
        on: .main,
        in: .common
      ).autoconnect().values
      
      for await _ in timer {
        guard self.checkConnectionStatus() else {
          continue
        }
        
        do {
          try await retryTask()
          break
        } catch {
          continue
        }
      }
    }
  }
  
  private func run(
    id: RetryTaskKey,
    work: @escaping @Sendable () async throws -> Void
  ) {
    let task = Task { @Sendable [weak self] in
      do {
        try await work()
      }
      
      self?.lock.withLock {
        self?.tasks[id] = nil
      }
    }
    
    self.lock.withLock {
      self.tasks[id] = task
    }
  }
  
  public func cancelRetry() {
    self.cancel(.networkReconnectionRetry)
    self.cancel(.periodicRetry)
  }
  
  private func cancel(_ id: RetryTaskKey) {
    self.lock.withLock {
      self.tasks[id]?.cancel()
      self.tasks[id] = nil
    }
  }
}

enum RetryTaskKey: Hashable {
  case networkReconnectionRetry
  case periodicRetry
}

extension NetworkRetryManager {
  private func checkConnectionStatus() -> Bool {
    let isConnected = self.networkMonitor.currentPath.status == .satisfied
    return isConnected
  }
}
