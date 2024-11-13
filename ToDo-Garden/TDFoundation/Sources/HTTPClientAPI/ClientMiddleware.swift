//
//  ClientMiddleware.swift
//  TDFoundation
//
//  Created by Noah on 11/11/24.
//

import Foundation

public protocol ClientMiddleware: Sendable {
  func intercept(
    request: HTTPRequest,
    next: @Sendable (HTTPRequest) async throws -> HTTPResponse
  ) async throws -> HTTPResponse
}
