//
//  CommonHeaderMiddleWare.swift
//  TDFoundation
//
//  Created by SONG on 1/7/25.
//

import Foundation

import HTTPClientAPI

public struct CommonHeaderMiddleware: ClientMiddleware {
  public init() {}

  public func intercept(
    request: HTTPRequest,
    next: @Sendable (HTTPRequest) async throws -> HTTPResponse
  ) async throws -> HTTPResponse {
    guard let accessTokenData = try? KeychainManager.shared.load(forKey: KeychainManager.KeychainKey.accessToken),
      let accessTokenString = String(data: accessTokenData, encoding: .utf8) else {
      throw KeychainError.nonExistentKey
    }

    var updatedRequest = request
    updatedRequest.header["Content-Type"] = "application/json"
    updatedRequest.header["Authorization"] = "Bearer \(accessTokenString)"

    switch updatedRequest.method {
    case .get:
      updatedRequest.header["Accept-Profile"] = "todogarden"
    default:
      updatedRequest.header["Content-Profile"] = "todogarden"
    }

    return try await next(updatedRequest)
  }
}
