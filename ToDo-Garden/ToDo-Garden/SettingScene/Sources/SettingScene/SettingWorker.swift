//
//  SettingWorker.swift
//  
//
//  Created by Wood on 8/5/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit.UIImage

import HTTPClientAPI
import SettingSceneAPI
import SettingSceneEntity
import TDFoundation

public struct SettingWorker: SettingWorkable {
  private let httpClient: HTTPClientAPI

  public init(httpClient: HTTPClientAPI) {
    self.httpClient = httpClient
  }

  public func requestUserInfo() async throws -> Setting.UserInfo {
    let data = try await self.httpClient.send(
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
        
        return try JSONDecoder().decode(Setting.FetchUserInfo.ResponseDTO.self, from: body)
      }
    )

    let imageUrlString = URLConstants.Profile.getProfileImage.absoluteString + data.id + "/image.jpeg"
    let imageUrl = URL(string: imageUrlString)
    return Setting.UserInfo(imageUrl: imageUrl, nickname: data.nickname)
  }
}

extension SettingWorker {
  private enum MockData {
    static let nickName = "울버린"
    static let imageData = Data()
  }
}
