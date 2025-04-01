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
import SharedEntity
import TDFoundation
import TDFoundationExtension

public struct HomeSceneWorker: HomeSceneWorkable, Sendable {
  private let httpClient: HTTPClientAPI
  private let homeStorage: any JSONStorable<SharedEntity.TodoBatchItem>

  public init(
    httpClient: HTTPClientAPI,
    homeStorage: some JSONStorable<SharedEntity.TodoBatchItem>
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
  
  public func writeJSONFile(data: [SharedEntity.TodoBatchItem]) async throws {
    var storedItems = (try? self.homeStorage.getItems()) ?? []
    
    for item in data {
      if let index = storedItems.firstIndex(where: { $0.localId == item.localId }) {
        storedItems[index] = item
      } else {
        storedItems.append(item)
      }
    }
    
    try self.homeStorage.saveItems(storedItems)
  }
  
  public func requestBatchUpdateToServer() async throws {
    let storedItems = (try? self.homeStorage.getItems()) ?? []
    if storedItems.count == .zero { return }
    
    let body = try JSONEncoder().encode(HomeScene.BatchUpdate.TodoBatchRequest(data: storedItems))
    let request = HTTPRequest(
      method: HTTPMethod.post,
      endPoint: URLConstants.ToDo.todoBatch,
      body: body
    )
    
    try await self.httpClient.send(
      input: request,
      serializer: { $0 },
      deserializer: { response in
        try response.validateStatusCode()
      }
    )
    
    try self.homeStorage.deleteAllItems()
  }
  
  public func deleteToDo() async throws {
    
  }
}
