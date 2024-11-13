//
//  HTTPClient.swift
//  TDFoundation
//
//  Created by Noah on 11/7/24.
//

import Foundation

import HTTPClientAPI

public struct HTTPClient: Sendable {
  public var transport: any ClientTransport
  public var middlewares: [any ClientMiddleware]
  
  public init(
    transport: any ClientTransport,
    middlewares: [any ClientMiddleware]
  ) {
    self.transport = transport
    self.middlewares = middlewares
  }
}

extension HTTPClient {
  @Sendable private func wrappingErrors<Result>(
    work: () async throws -> Result,
    mapError: (any Error) -> HTTPClientErrorContext
  ) async throws -> Result {
    do {
      return try await work()
    } catch {
      throw mapError(error)
    }
  }
  
  @Sendable private func makeError(
    request: HTTPRequest? = nil,
    response: HTTPResponse? = nil,
    error: any Error
  ) -> HTTPClientErrorContext {
    let underlyingError: any Error
    
    if let clientError = error as? HTTPClientError,
      let unwrappedUnderlyingError = clientError.underlyingError {
      underlyingError = unwrappedUnderlyingError
    } else {
      underlyingError = error
    }
    
    return HTTPClientErrorContext(
      request: request,
      response: response,
      underlyingError: underlyingError
    )
  }
}
