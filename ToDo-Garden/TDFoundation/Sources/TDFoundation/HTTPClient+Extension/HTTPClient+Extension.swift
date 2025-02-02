//
//  HTTPClient+Extension.swift
//  TDFoundation
//
//  Created by SONG on 2/1/25.
//

import Foundation

import HTTPClient
import HTTPClientAPI

extension HTTPClient: HTTPClientCustomable {
  @TaskLocal
  private static var current: HTTPClient = HTTPClient.live
  
  public func sendWithCustomMiddlewares<Input, Output>(
    middlewares: [any ClientMiddleware],
    input: Input,
    serializer: @Sendable (Input) throws -> HTTPRequest,
    deserializer: @Sendable (HTTPResponse) throws -> Output
  ) async throws -> Output where Input: Sendable, Output: Sendable {
    return try await self.replaceMiddlewares(middlewares) { @Sendable in
      try await HTTPClient.current.send(
        input: input,
        serializer: serializer,
        deserializer: deserializer
      )
    }
  }
  
  private func replaceMiddlewares<Result>(
    _ newMiddlewares: [any ClientMiddleware],
    operation: () async throws -> Result
  ) async rethrows -> Result {
    try await HTTPClient.$current.withValue(
      HTTPClient(
        transport: HTTPClient.live.transport,
        middlewares: newMiddlewares
      )
    ) {
      try await operation()
    }
  }
}

extension HTTPClient {
  public static let live = Self(
    transport: URLSessionTransport(urlSession: URLSession.shared),
    middlewares: [
      AuthenticationMiddleWare(),
      CommonHeaderMiddleware(),
      RefreshMiddleware.live
    ]
  )
}

extension RefreshMiddleware {
  public static let live = RefreshMiddleware(accessTokenManager: AccessTokenManager.live)
}

extension AccessTokenManager {
  static let live = AccessTokenManager(
    httpClient: HTTPClient(
      transport: URLSessionTransport(urlSession: URLSession.shared),
      middlewares: [
        AuthenticationMiddleWare(),
        CommonHeaderMiddleware()
      ]
    )
  )
}
