import Foundation

import class TDUtility.LockIsolated
// swiftlint:disable type_name
public protocol Requestable: Sendable {
  associatedtype ID: Hashable, Sendable
  associatedtype Response: Sendable
  func execute(id: ID) async throws -> Response
}

public final class Cache<Request: Requestable>: Sendable {
  let request: Request
  
  typealias Continuation = CheckedContinuation<Request.Response, any Error>
  enum RequestState: Sendable {
    case response(Request.Response)
    case loading(Task<Void, Never>, [Continuation])
  }
  let cachedStates = LockIsolated<[Request.ID: RequestState]>([:])
  
  public init(request: Request) {
    self.request = request
  }
  
  public func execute(_ id: Request.ID) async throws -> Request.Response {
    try await withTaskCancellationHandler {
      try await withCheckedThrowingContinuation { continuation in
        self.cachedStates.withValue { state in
          switch state[id] {
          case .response(let response):
            continuation.resume(returning: response)
            
          case .loading(let task, var continuations):
            continuations.append(continuation)
            state[id] = .loading(task, continuations)
            
          case nil:
            state[id] = .loading(
              self.buildTask(id),
              [continuation]
            )
          }
        }
      }
    } onCancel: {
      guard case .loading(let task, _) = self.cachedStates[id] else { return }
      task.cancel()
    }
  }
  
  private func buildTask(_ id: Request.ID) -> Task<Void, Never> {
    Task {
      do {
        let response = try await self.request.execute(id: id)
        self.cachedStates.withValue { state in
          guard case .loading(_, let continuations) = state[id] else { return }
          for continuation in continuations {
            continuation.resume(returning: response)
          }
          state[id] = .response(response)
        }
      } catch {
        self.cancel(id)
      }
    }
  }
  
  public func cancel(_ id: Request.ID) {
    let continuations: [Continuation] = self.cachedStates.withValue { state in
      guard case .loading(_, let continuations) = state[id] else { return [] }
      state[id] = nil
      return continuations
    }
    for continuation in continuations {
      continuation.resume(throwing: CancellationError())
    }
  }
}
// swiftlint:enable type_name
