//
//  HTTPClientAPI.swift
//  TDFoundation
//
//  Created by Noah on 11/11/24.
//

import Foundation

public protocol HTTPClientAPI: Sendable {
  func send<OperationInput, OperationOutput>(
    input: OperationInput,
    serializer: @Sendable (OperationInput) throws -> HTTPRequest,
    deserializer: @Sendable (HTTPResponse) throws -> OperationOutput
  ) async throws -> OperationOutput where OperationInput: Sendable, OperationOutput: Sendable
}
