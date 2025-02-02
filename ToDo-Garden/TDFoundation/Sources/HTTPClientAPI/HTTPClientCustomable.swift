//
//  HTTPClientCustomable.swift
//  TDFoundation
//
//  Created by SONG on 2/1/25.
//

public protocol HTTPClientCustomable: HTTPClientAPI {
  func sendWithCustomMiddlewares<Input: Sendable, Output: Sendable>(
    middlewares: [any ClientMiddleware],
    input: Input,
    serializer: @Sendable (Input) throws -> HTTPRequest,
    deserializer: @Sendable (HTTPResponse) throws -> Output
  ) async throws -> Output
}
