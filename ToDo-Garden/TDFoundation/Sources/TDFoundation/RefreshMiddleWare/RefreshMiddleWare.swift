//
//  RefreshMiddleware.swift
//  TDFoundation
//
//  Created by SONG on 12/30/24.
//

import Foundation

import HTTPClientAPI

public struct RefreshMiddleware: ClientMiddleware {
  private let accessTokenManager: AccessTokenManagerAPI
  
  public init(accessTokenManager: AccessTokenManagerAPI) {
    self.accessTokenManager = accessTokenManager
  }
  
  public func intercept(
    request: HTTPRequest,
    next: @Sendable (HTTPRequest) async throws -> HTTPResponse
  ) async throws -> HTTPResponse {
    let response = try await next(request)
    // 토큰 만료 응답 체크
    guard response.statusCode == 401,
      let body = response.body,
      let decodedBody = try? JSONDecoder().decode(
        RefreshDTO.ErrorResponse.self,
        from: body
      ),
      decodedBody.code == "PGRST301" else {
      return response
    }
    
    // 토큰 갱신
    let (newAccessToken, _) = try await self.accessTokenManager.refreshAccessToken()
    let newRequest = try self.addAuthHeader(to: request, using: newAccessToken)
    
    // 갱신된 토큰으로 요청 재시도
    return try await next(newRequest)
  }
  
  private func addAuthHeader(to request: HTTPRequest, using accessToken: String) throws -> HTTPRequest {
    var newRequest = request
    newRequest.header["Authorization"] = "Bearer \(accessToken)"
    return newRequest
  }
}
