//
//  TimerStorageWorker.swift
//  TimerScene
//
//  Created by SONG on 1/23/25.
//

import Foundation

import HTTPClientAPI
import TDFoundation
import TimerSceneEntity

public struct TimerStorageWorker: TimerStorageWorkable, Sendable {
  public let httpClient: HTTPClientAPI
  private let timerStorage: TimerStorage
  
  public init(httpClient: HTTPClientAPI) throws {
    self.httpClient = httpClient
    self.timerStorage = try TimerStorage()
  }
  
  func postCompletedItem() async throws {
    let body = try JSONEncoder().encode(self.getTimerItemsAsDTO())
    let request = HTTPRequest(
      method: HTTPMethod.post,
      endPoint: URLConstants.Timer.postCompletedTimerItems,
      body: body
    )
    
    try await self.httpClient.send(
      input: request,
      serializer: { $0 },
      deserializer: { response in
        guard response.statusCode == 204 else {
          throw HTTPClientError.badStatusCode(response.statusCode)
        }
        try self.deleteAllTimerItems()
      }
    )
  }
}

// MARK: - Local Methods
extension TimerStorageWorker {
  func recordCompletedItemInLocal(groupId: String, duration: Int) throws {
    try self.timerStorage.saveCompletedTimer(groupId: groupId, duration: duration)
  }
  
  func deleteAllTimerItems() throws {
    try self.timerStorage.deleteAllPomodoros()
  }
  
  func getTimerItemsAsDTO() throws -> TimerScene.FocusTimeRequestDTO {
    return try self.timerStorage.getAsDTO()
  }
}
