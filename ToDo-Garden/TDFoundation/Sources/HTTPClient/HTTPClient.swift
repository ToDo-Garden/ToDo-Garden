//
//  HTTPClient.swift
//  TDFoundation
//
//  Created by Noah on 11/7/24.
//

import Foundation

import HTTPClientAPI

public struct HTTPClient: Sendable, HTTPClientAPI {
  public var transport: any ClientTransport
  public var middlewares: [any ClientMiddleware]
  
  public init(
    transport: any ClientTransport,
    middlewares: [any ClientMiddleware]
  ) {
    self.transport = transport
    self.middlewares = middlewares
  }
  
  // swiftlint:disable function_body_length identifier_name
  public func send<Input, Output>(
    input: Input,
    serializer: @Sendable (Input) throws -> HTTPRequest,
    deserializer: @Sendable (HTTPResponse) throws -> Output
  ) async throws -> Output where Input: Sendable, Output: Sendable {
    let request: HTTPRequest = try await self.wrappingErrors {
      return try serializer(input)
    } mapError: { _ in
      return self.makeError(error: HTTPClientError.serializationError)
    }
    
    var next: @Sendable (HTTPRequest) async throws -> HTTPResponse = { _request in
      return try await self.wrappingErrors {
        return try await self.transport.send(request: _request)
      } mapError: { error in
        return self.makeError(
          request: request,
          error: HTTPClientError.transportFailed(error)
        )
      }
    }
    
    for middleWare in self.middlewares.reversed() {
      let temp = next
      next = { _request in
        return try await self.wrappingErrors {
          return try await middleWare.intercept(
            request: _request,
            next: temp
          )
        } mapError: { error in
          return self.makeError(
            request: request,
            error: HTTPClientError.middlewareFailed(
              middlewareType: type(of: middleWare),
              error
            )
          )
        }
      }
    }
    
    let response = try await next(request)
    
    return try await self.wrappingErrors {
      return try deserializer(response)
    } mapError: { _ in
      return self.makeError(
        request: request,
        response: response,
        error: HTTPClientError.deserializationError
      )
    }
  }
  // swiftlint:enable function_body_length identifier_name
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
