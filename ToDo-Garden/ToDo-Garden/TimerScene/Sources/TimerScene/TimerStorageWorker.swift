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
  private let timerStorage: any JSONStorable<TimerScene.PomodoroDTO>
  
  public init(
    httpClient: HTTPClientAPI,
    timerStorage: some JSONStorable<TimerScene.PomodoroDTO>
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
  public func recordCompletedItemInLocal(groupId: String, seconds: Int) throws {
    let today = self.getCurrentDateString()
    
    try self.timerStorage.updateOrAddItem(
      where: { $0.focusGroupId == groupId && $0.focusDate == today },
      update: { pomodoro in
        var updatedFocusTime = pomodoro.focusTime
        updatedFocusTime.append(seconds)
        updatedFocusTime.sort()
        pomodoro.focusTime = updatedFocusTime
      },
      new: {
        return TimerScene.PomodoroDTO(
          focusGroupId: groupId,
          focusDate: today,
          focusTime: [seconds]
        )
      }
    )
  }
  
  public func deleteAllTimerItems() throws {
    try self.timerStorage.deleteAllItems()
  }
  
  public func getTimerItemsAsDTO() throws -> TimerScene.FocusTimeRequestDTO {
    let pomodoros = try self.timerStorage.getItems()
    let dto = TimerScene.FocusTimeRequestDTO(pomodoros: pomodoros)
    return dto
  }
  
  private func getCurrentDateString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: Date())
  }
}

public extension TimerStorageWorker {
  static func live(
    httpClient: HTTPClientAPI,
    timerStorage: any JSONStorable<TimerScene.PomodoroDTO>
  ) -> TimerStorageWorker {
    return TimerStorageWorker(
      httpClient: httpClient,
      timerStorage: timerStorage
    )
  }
}
