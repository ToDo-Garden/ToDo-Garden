//
//  NetworkRetryManagerAPI.swift
//  TDFoundation
//
//  Created by SONG on 2/25/25.
//

public protocol NetworkRetryManagerAPI: Sendable {
  var retryTask: (@Sendable () async throws -> Void)? { get set }
  func execute(isRetryingOn: Bool)
  func cancelRetry()
  func isConnected() -> Bool
}
