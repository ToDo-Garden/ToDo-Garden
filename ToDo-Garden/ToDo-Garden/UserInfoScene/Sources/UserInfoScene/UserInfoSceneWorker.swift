//
//  UserInfoSceneWorker.swift
//  
//
//  Created by Wood on 8/28/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit.UIImage

import HTTPClientAPI
import TDFoundation
import ToDoGardenUIResource
import UserInfoSceneAPI
import UserInfoSceneEntity

public struct UserInfoSceneWorker: UserInfoSceneWorkable {
  let httpClient: HTTPClientAPI
  let signout: () -> Void

  public func requestChangeProfileImage(with data: Data) async throws {
    let userIDString = try self.getUserID()
    let imageURLString = URLConstants.Profile.changeProfileImage.absoluteString + userIDString + "/image.jpeg"
    
    guard let url = URL(string: imageURLString) else {
      throw NSError(domain: "URL decoding error", code: 0)
    }
    
    let request = HTTPRequest(
      method: .put,
      endPoint: url,
      header: [
        "Content-Type": "image/jpeg"
      ],
      body: data
    )
    
    try await self.httpClient.send(
      input: request,
      serializer: { $0 },
      deserializer: { response in
        guard response.statusCode >= 200 && response.statusCode < 400 else {
          throw HTTPClientError.badStatusCode(response.statusCode)
        }
      }
    )
  }

  // swiftlint: disable function_body_length
  public func requestUserProfile(urlString: String) async throws -> String {
    let request = HTTPRequest(
      method: HTTPMethod.get,
      endPoint: URLConstants.Profile.getUserProfile
    )
    
    let result = try await self.httpClient.send(
      input: request,
      serializer: { $0 },
      deserializer: { response in
        guard response.statusCode >= 200 && response.statusCode < 400 else {
          throw HTTPClientError.badStatusCode(response.statusCode)
        }
        
        guard let body = response.body else {
          throw HTTPClientError.deserializationError
        }
        
        let result = try JSONDecoder().decode(UserInfoScene.GetProfileResponseDTO.self, from: body)
        return result
      }
    )
    
    let data = UserInfoScene.UserInfo.self
    if urlString == data.nickName.rawValue {
      return result.nickname
    } else if urlString == data.introduction.rawValue {
      return result.introduction
    } else if urlString == data.id.rawValue {
      return result.customId
    } else {
      return result.email
    }
  }
  // swiftlint: enable function_body_length

  public func requestWithdraw() async throws {
    let request = HTTPRequest(
      method: HTTPMethod.post,
      endPoint: URLConstants.Auth.withDrawURL
    )
    
    try await self.httpClient.send(
      input: request,
      serializer: { $0 },
      deserializer: { response in
        guard response.statusCode >= 200 && response.statusCode < 300 else {
          throw HTTPClientError.badStatusCode(response.statusCode)
        }
      }
    )
  }

  @MainActor
  public func requestSignOut() async throws {
    self.signout()
    let request = HTTPRequest(
      method: HTTPMethod.post,
      endPoint: URLConstants.Auth.logoutURL
    )
    
    try await self.httpClient.send(
      input: request,
      serializer: { $0 },
      deserializer: { response in
        guard response.statusCode >= 200 && response.statusCode < 300 else {
          throw HTTPClientError.badStatusCode(response.statusCode)
        }
      }
    )
  }
  
  public func requestProfileImage() async throws -> UIImage? {
    let userIDString = try self.getUserID()
    let imageURLString = URLConstants.Profile.changeProfileImage.absoluteString + userIDString + "/image.jpeg"
    
    guard let url = URL(string: imageURLString) else {
      throw NSError(domain: "URL decoding error", code: 0)
    }
    
    // TODO: 이미지 캐시 객체로 대체예정
    
    let request = HTTPRequest(
      method: HTTPMethod.get,
      endPoint: url
    )
    
    let imageData = try await self.httpClient.send(
      input: request,
      serializer: { $0 },
      deserializer: { response in
        return response.body
      }
    )
    
    guard let result = imageData,
      let image = UIImage(data: result) else {
      return nil
    }
    
    return image
  }
}

extension UserInfoSceneWorker {
  private func getUserID() throws -> String {
    guard let userID = try KeychainManager.shared.load(forKey: KeychainManager.KeychainKey.userIdentifier),
      let userIDString = String(data: userID, encoding: .utf8) else {
      throw KeychainError.unknownKeyChainError
    }
    return userIDString
  }
}

extension UserInfoSceneWorker {
  private enum MockData {
    static let nickName = "울버린"
    static let introduction = "나는 나뭇잎 마을의"
    static let id = "@noah0316"
    static let email = "dev.noah0316@gmail.com"
  }
}
