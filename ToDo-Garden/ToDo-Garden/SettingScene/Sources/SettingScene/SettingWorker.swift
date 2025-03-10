//
//  SettingWorker.swift
//  
//
//  Created by Wood on 8/5/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import HTTPClientAPI
import SettingSceneAPI
import SettingSceneEntity
import TDFoundation

public struct SettingWorker: SettingWorkable {
  private let httpClient: HTTPClientAPI

  public init(httpClient: HTTPClientAPI) {
    self.httpClient = httpClient
  }

  public func requestUserNickName() async throws -> String {
    return try await self.httpClient.send(
      input: Setting.FetchUserInfo.RequestDTO(),
      serializer: { _ in
        return HTTPRequest(
          method: HTTPMethod.get,
          endPoint: URLConstants.Profile.getUserProfile
        )
      },
      deserializer: { response in
        guard response.statusCode >= 200 && response.statusCode < 400 else {
          throw HTTPClientError.badStatusCode(response.statusCode)
        }

        guard let body = response.body else {
          throw HTTPClientError.deserializationError
        }

        return try JSONDecoder().decode(Setting.FetchUserInfo.ResponseDTO.self, from: body).nickname
      }
    )
  }

  public func requestUserProfileImage() async -> Data {
    return MockData.imageData
  }
}

extension SettingWorker {
  private enum MockData {
    static let nickName = "울버린"
    static let imageData = Data()
  }
}
