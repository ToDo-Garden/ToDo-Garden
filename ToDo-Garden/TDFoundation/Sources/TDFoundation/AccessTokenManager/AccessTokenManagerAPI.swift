//
//  AccessTokenManagerAPI.swift
//  TDFoundation
//
//  Created by SONG on 1/4/25.
//

public protocol AccessTokenManagerAPI: Sendable {
  typealias AccessToken = String
  typealias RefreshToken = String
  
  func getValidAccessToken() async throws -> AccessToken
  func refreshAccessToken() async throws -> (AccessToken, RefreshToken)
}
