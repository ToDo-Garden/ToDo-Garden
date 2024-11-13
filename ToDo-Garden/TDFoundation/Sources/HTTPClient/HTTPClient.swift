//
//  HTTPClient.swift
//  TDFoundation
//
//  Created by Noah on 11/7/24.
//

import Foundation

import HTTPClientAPI

public struct HTTPClient: Sendable {
}

extension HTTPClient {
  @Sendable func wrappingErrors<Result>(
    work: () async throws -> Result,
    mapError: (any Error) -> HTTPClientErrorContext
  ) async throws -> Result {
    do {
      return try await work()
    } catch {
      throw mapError(error)
    }
  }
}
