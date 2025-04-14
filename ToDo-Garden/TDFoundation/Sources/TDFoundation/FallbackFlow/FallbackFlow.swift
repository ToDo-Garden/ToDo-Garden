//
//  FallbackFlow.swift
//  TDFoundation
//
//  Created by SONG on 4/9/25.
//

public enum FallbackFlow {
  @MainActor public static func run<T: Sendable>(
    online: @escaping () async throws -> T,
    offline: @escaping () async throws -> T,
    handleError: ((Error) -> Void)? = nil,
    checkNetworkConnection: (() -> Bool)
  ) async -> T? {
    if checkNetworkConnection() {
      do {
        return try await online()
      } catch {
        do {
          return try await offline()
        } catch {
          handleError?(error)
          return nil
        }
      }
    } else {
      do {
        return try await offline()
      } catch {
        handleError?(error)
        return nil
      }
    }
  }
}
