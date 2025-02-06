//
//  TimerStorageWorker.swift
//  TimerScene
//
//  Created by SONG on 1/23/25.
//

import Foundation

import HTTPClientAPI
import TDFoundation
import TimerSceneAPI
import TimerSceneEntity

public struct TimerStorageWorker: TimerStorageWorkable {
  private var httpClient: HTTPClientAPI?
  private let timerStorage: TimerStorable
  
  public init(
    httpClient: HTTPClientAPI,
    timerStorage: TimerStorable
  ) {
    self.httpClient = httpClient
    self.timerStorage = timerStorage
  }
  
  public func postCompletedItem() async throws {
    let body = try JSONEncoder().encode(self.getTimerItemsAsDTO())
    let request = HTTPRequest(
      method: HTTPMethod.post,
      endPoint: URLConstants.Timer.postCompletedTimerItems,
      body: body
    )
    
    try await self.httpClient?.send(
      input: request,
      serializer: { $0 },
      deserializer: { response in
        // MARK: 현재 홈화면의 부재로 payload를 통해 들어오는 GroupID가 없어서, 실패 응답 옴
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
  public func recordCompletedItemInLocal(groupId: String, duration: Int) throws {
    try self.timerStorage.saveCompletedTimer(groupId: groupId, duration: duration)
  }
  
  public func deleteAllTimerItems() throws {
    try self.timerStorage.deleteAllPomodoros()
  }
  
  public func getTimerItemsAsDTO() throws -> TimerScene.FocusTimeRequestDTO {
    return try self.timerStorage.getAsDTO()
  }
}
