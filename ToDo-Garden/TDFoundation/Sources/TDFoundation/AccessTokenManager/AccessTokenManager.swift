//
//  AccessTokenManager.swift
//  TDFoundation
//
//  Created by SONG on 1/4/25.
//

import Foundation

import HTTPClientAPI

public actor AccessTokenManager: AccessTokenManagerAPI {
  public typealias AccessToken = String
  public typealias RefreshToken = String
  
  private let httpClient: HTTPClientAPI
  private var refreshTask: Task<(AccessToken, RefreshToken), Error>?
  
  public init(httpClient: HTTPClientAPI) {
    self.httpClient = httpClient
  }
  
  public func getValidAccessToken() async throws -> AccessToken {
    guard let accessTokenData = try KeychainManager.shared.load(forKey: KeychainManager.KeychainKey.accessToken),
      let accessToken = String(data: accessTokenData, encoding: .utf8) else {
      throw KeychainError.nonExistentKey
    }
    return accessToken
  }
  
  // swiftlint: disable function_body_length
  public func refreshAccessToken() async throws -> (AccessToken, RefreshToken) {
    if let inProgressTask = self.refreshTask {
      return try await inProgressTask.value
    }
    
    let task = Task<(AccessToken, RefreshToken), Error> {
      defer { self.refreshTask = nil }
      
      let request = try self.makeRequest()

      let result = try await self.httpClient.send(
        input: request,
        serializer: { $0 },
        deserializer: { response in
          guard let body = response.body else {
            throw HTTPClientError.deserializationError
          }
          
          let tokens = try JSONDecoder().decode(RefreshDTO.Response.self, from: body)
          
          try KeychainManager.shared.update(
            Data(tokens.accessToken.utf8),
            forKey: KeychainManager.KeychainKey.accessToken
          )
          
          try KeychainManager.shared.update(
            Data(tokens.refreshToken.utf8),
            forKey: KeychainManager.KeychainKey.refreshToken
          )
          
          return tokens
        }
      )
      return (result.accessToken, result.refreshToken)
    }
    
    self.refreshTask = task
    return try await task.value
  }
}

extension AccessTokenManager {
  private func makeRequest() throws -> HTTPRequest {
    guard let refreshTokenData = try KeychainManager.shared.load(forKey: KeychainManager.KeychainKey.refreshToken),
      let refreshToken = String(data: refreshTokenData, encoding: .utf8) else {
      throw KeychainError.nonExistentKey
    }
    
    // 요청 생성
    let request = HTTPRequest(
      method: .post,
      endPoint: URLConstants.Auth.refreshTokenURL,
      header: [
        "Content-Type": "application/json"
      ],
      body: try JSONEncoder().encode(RefreshDTO.Request(refreshToken: refreshToken))
    )
    return request
  }
}
// swiftlint: enable function_body_length
