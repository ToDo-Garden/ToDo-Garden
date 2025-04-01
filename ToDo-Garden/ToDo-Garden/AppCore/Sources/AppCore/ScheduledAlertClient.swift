@preconcurrency import Combine
import Foundation

import TDFoundation

import SharingGRDB

public struct ScheduledAlertClient: Sendable {
  public var stream: @Sendable () -> AsyncStream<()>
  
  public init(stream: @Sendable @escaping () -> AsyncStream<Void>) {
    self.stream = stream
  }
}

extension ScheduledAlertClient {
  public static let live = Self(
    stream: {
      @SharedReader(.fetch(DailyToDoAlerts())) var fetchedAlerts: [DailyToDoAlert]
      let alertSchedule = LockIsolated<[Double: Bool]>([:])
      
      let cancellable = $fetchedAlerts.publisher
        .debounce(for: 1, scheduler: DispatchQueue.global())
        .removeDuplicates()
        .map {
          $0.reduce(into: [Double: Bool]()) {
            $0[$1.alertTime] = $1.isRepeating
          }
        }
        .sink { alertSchedule.setValue($0) }
      
      let (stream, continuation) = AsyncStream<Void>.makeStream()
      let task = Task {
        while true {
          try await Task.sleep(nanoseconds: 60 * NSEC_PER_SEC)
          let key = Date().asDouble()
          if let isRepeating = alertSchedule[key], isRepeating {
            continuation.yield(())
          }
        }
      }
      
      continuation.onTermination = { _ in
        cancellable.cancel()
        task.cancel()
      }
      
      return stream
    }
  )
}
