//
//  RefreshMiddleware.swift
//  TDFoundation
//
//  Created by SONG on 12/30/24.
//

import Foundation

import HTTPClientAPI

public final class RefreshMiddleware: ClientMiddleware {
  private let keychainManager: KeychainManager
  private let transport: ClientTransport & Sendable
  private let taskManager = RefreshTaskManager()
  
  public init(
    keychainManager: KeychainManager = .shared,
    transport: ClientTransport & Sendable
  ) {
    self.keychainManager = keychainManager
    self.transport = transport
  }
  
  public func intercept(
    request: HTTPRequest,
    next: @Sendable (HTTPRequest) async throws -> HTTPResponse
  ) async throws -> HTTPResponse {
    let response = try await next(request)
    
    guard response.statusCode == 401 else {
      return response
    }
    
    // Refresh token 작업 관리
    try await self.taskManager.performRefreshIfNeeded { [weak self] in
      guard let (newAccessToken, newRefreshToken) = try await self?.refreshTokens() else { return }
      
      guard let userIdentifierData = try self?.keychainManager.load(
        forKey: KeychainManager.KeychainKey.userIdentifier
      ),
        let userIdentifier = String(data: userIdentifierData, encoding: .utf8) else {
        throw KeychainError.nonExistentKey
      }
      
      try self?.keychainManager.saveAccessToken(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
        userIdentifier: userIdentifier
      )
    }
    
    // 리프레시된 토큰으로 헤더 교체
    let newRequest = try self.addAuthHeader(to: request)
    // 리프레시된 토큰으로 해당 작업 재시도
    return try await next(newRequest)
  }
}

extension RefreshMiddleware {
  private func addAuthHeader(to request: HTTPRequest) throws -> HTTPRequest {
    var newRequest = request
    
    guard let accessTokenData = try self.keychainManager.load(forKey: KeychainManager.KeychainKey.accessToken),
      let accessToken = String(data: accessTokenData, encoding: .utf8) else {
      throw KeychainError.nonExistentKey
    }
    
    newRequest.header["Authorization"] = "Bearer \(accessToken)"
    return newRequest
  }
  
  private func refreshTokens() async throws -> (accessToken: String, refreshToken: String) {
    let jsonDecoder = JSONDecoder()
    let request = try makeHTTPRequest()
    
    // Transport를 직접 사용하여 요청 전송
    let response = try await transport.send(request: request)
    
    // Response 처리
    guard let data = response.body else {
      throw HTTPClientError.deserializationError
    }
    
    let tokens = try jsonDecoder.decode(RefreshDTO.Response.self, from: data)
    return (tokens.accessToken, tokens.refreshToken)
  }
  
  private func makeHTTPRequest() throws -> HTTPRequest {
    guard let accessTokenData = try self.keychainManager.load(forKey: KeychainManager.KeychainKey.accessToken),
      let accessToken = String(data: accessTokenData, encoding: .utf8),
      let refreshTokenData = try self.keychainManager.load(forKey: KeychainManager.KeychainKey.refreshToken),
      let refreshToken = String(data: refreshTokenData, encoding: .utf8) else {
      throw KeychainError.nonExistentKey
    }

    return HTTPRequest(
      method: .post,
      endPoint: URLConstants.Auth.refreshTokenURL,
      header: [
        "Authorization": "Bearer \(accessToken)",
        "Content-Type": "application/json",
        "apiKey" : try KeyConstants.supabaseAPIKey
      ],
      body: try JSONEncoder().encode(RefreshDTO.Request(refreshToken: refreshToken))
    )
  }
}

// MARK: - Actor로 감싸서 refreshTask에 대한 스레드 안전성 보장
actor RefreshTaskManager {
  private var refreshTask: Task<Void, Error>?
  
  func performRefreshIfNeeded(
    refresh: @escaping @Sendable () async throws -> Void
  ) async throws {
    if let existingTask = self.refreshTask {
      try await existingTask.value
    } else {
      let task = Task {
        defer { self.refreshTask = nil }
        try await refresh()
      }
      self.refreshTask = task
      try await task.value
    }
  }
}
