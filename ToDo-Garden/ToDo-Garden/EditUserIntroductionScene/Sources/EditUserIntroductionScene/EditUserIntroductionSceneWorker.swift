//
//  EditUserIntroductionSceneWorker.swift
//  
//
//  Created by Wood on 10/7/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import EditUserIntroductionSceneAPI
import EditUserIntroductionSceneEntity
import HTTPClientAPI
import TDFoundation

public struct EditUserIntroductionSceneWorker: EditUserIntroductionSceneWorkable {
  private let httpClient: HTTPClientAPI
  
  public init(httpClient: HTTPClientAPI) {
    self.httpClient = httpClient
  }
  public func editUserIntroduction(_ introduction: String) async throws {
    let body = try JSONEncoder().encode(
      EditUserIntroductionScene.ChangeIntroduction.RequestDTO(introduction: introduction)
    )
    let request = HTTPRequest(
      method: HTTPMethod.post,
      endPoint: URLConstants.Profile.changeIntroduction,
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
