//
//  HomeSceneWorker.swift
//  HomeScene
//
//  Created by Noah on 1/9/25.
//  Copyright (c) 2025 ToDoGarden. All rights reserved.

import Foundation

import HomeSceneAPI
import HomeSceneEntity
import HTTPClientAPI
import TDFoundation
import TDFoundationExtension

public struct HomeSceneWorker: HomeSceneWorkable, Sendable {
  private let httpClient: HTTPClientAPI
  private let homeStorage: any JSONStorable<HomeScene.TodoBatchItem>
  
  public init(
    httpClient: HTTPClientAPI,
    homeStorage: some JSONStorable<HomeScene.TodoBatchItem>
  ) {
    self.httpClient = httpClient
    self.homeStorage = homeStorage
  }
  
  public func fetchToDoList(dateString: String) async throws -> [HomeScene.FetchToDoList.Response] {
    let request = HTTPRequest(
      method: HTTPMethod.get,
      endPoint: URLConstants.ToDo.fetchToDoList,
      queryItems: ["target_date": dateString]
    )
    let fetchedToDoList = try await self.httpClient.send(
      input: request,
      serializer: { $0 },
      deserializer: { response in
        try response.validateStatusCode()
        let result: [HomeScene.FetchToDoList.Response] = try response.decode()
        return result
      }
    )
    return fetchedToDoList
  }
  
  public func createToDo() async throws {
    
  }
  
  public func deleteToDo() async throws {
    
  }
}
