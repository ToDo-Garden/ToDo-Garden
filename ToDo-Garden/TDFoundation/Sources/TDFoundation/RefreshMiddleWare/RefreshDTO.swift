//
//  Untitled.swift
//  TDFoundation
//
//  Created by SONG on 12/30/24.
//

// swiftlint: disable all
enum RefreshDTO {
  struct Request: Sendable, Encodable {
    let refresh_token: String
    let provider: String
    
    init(refreshToken: String) {
      self.refresh_token = refreshToken
      self.provider = "apple"
    }
  }
  
  struct Response: Sendable, Decodable {
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
      case accessToken = "access_token"
      case refreshToken = "refresh_token"
    }
  }
}
// swiftlint: enable all
