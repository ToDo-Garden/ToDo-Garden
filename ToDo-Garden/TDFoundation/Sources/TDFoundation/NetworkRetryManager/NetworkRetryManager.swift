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
  
  public func isConnected() -> Bool {
    return self.networkMonitor.currentPath.status.isConnected
  }
  
  private func setupNetworkMonitor() {
    let updateNetworkStatus = { @Sendable [weak self] in
      guard let isConnected = self?.networkMonitor.currentPath.status.isConnected else { return }
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
  
  public func execute(isRetryingOn: Bool = true) {
    self.networkMonitor.start(queue: .global(qos: .background))
    if isRetryingOn {
      self.startRetrying()
    }
  }
  
  private func startRetrying() {
    Task {
      self.startNetworkReconnectionObserver()
      self.startPeriodicRetry()
    }
  }
  
  private func startNetworkReconnectionObserver() {
    guard let retryTask = self.retryTask else { return }
    
    self.tasks[.networkReconnectionRetry] = Task { @Sendable in
      guard self.networkMonitor.currentPath.status.isConnected else { return }
      
      try await retryTask()
    }
  }
  
  private func startPeriodicRetry() {
    guard let retryTask = self.retryTask else { return }

    self.tasks[.periodicRetry] = Task { @Sendable in
      let timer = Timer.publish(
        every: self.retryInterval,
        on: .main,
        in: .common
      ).autoconnect().values
      
      for await _ in timer {
        guard self.networkMonitor.currentPath.status.isConnected else {
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
  
  public func cancelRetry() {
    self.tasks[.networkReconnectionRetry]?.cancel()
    self.tasks[.periodicRetry]?.cancel()
    self.tasks[.networkReconnectionRetry] = nil
    self.tasks[.periodicRetry] = nil
  }
}

enum RetryTaskKey: Hashable {
  case networkReconnectionRetry
  case periodicRetry
}

extension NWPath.Status {
  var isConnected: Bool {
    self == .satisfied
  }
}
