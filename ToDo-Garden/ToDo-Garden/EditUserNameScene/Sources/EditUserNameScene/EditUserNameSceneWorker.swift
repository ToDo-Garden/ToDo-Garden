//
//  EditUserNameSceneWorker.swift
//  
//
//  Created by Wood on 9/23/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import EditUserNameSceneAPI
import EditUserNameSceneEntity
import HTTPClientAPI
import TDFoundation

public struct EditUserNameSceneWorker: EditUserNameSceneWorkable {
  private let httpClient: HTTPClientAPI
  
  public init(httpClient: HTTPClientAPI) {
    self.httpClient = httpClient
  }

  public func requestEditUserName(_ userName: String) async throws {
    let body = try JSONEncoder().encode(
      EditUserNameScene.ChangeNickname.RequestDTO(nickname: userName)
    )
    let request = HTTPRequest(
      method: HTTPMethod.post,
      endPoint: URLConstants.Profile.changeNickname,
      body: body
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
}
