//
//  ShareGardenSceneWorker.swift
//  
//
//  Created by Noah on 7/4/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import HTTPClientAPI
import ShareGardenSceneAPI
import ShareGardenSceneEntity
import TDFoundation

public struct ShareGardenSceneWorker: ShareGardenSceneWorkable {
  private var httpClient: HTTPClientAPI?
  
  public init(httpClient: HTTPClientAPI) {
    self.httpClient = httpClient
  }
  
  public func requestFriendsGardenList() async throws -> [ShareGardenSceneEntity.ShareGardenScene.FriendsGarden] {
    let request = HTTPRequest(method: HTTPMethod.get, endPoint: URLConstants.Garden.loadMyFriendList)
    
    guard let friendGardens = try await self.httpClient?.send(
      input: request,
      serializer: { $0 },
      deserializer: { response in
        try self.checkStatusCode(response: response)
        let decodedBody: [ShareGardenScene.FriendGardenDTO] = try self.decodeBody(response: response)
        
        var result: [ShareGardenScene.FriendsGarden] = []
        for friendGardenDTO in decodedBody {
          let friendGarden = ShareGardenScene.FriendsGarden(
            id: UUID(uuidString: friendGardenDTO.id) ?? UUID(),
            nickname: friendGardenDTO.nickname,
            focusStreakDays: friendGardenDTO.maxstreakcount ?? Int.zero,
            pomodoroRecords: self.makePomodoroCollection(from: friendGardenDTO.pomodororecords)
          )
          result.append(friendGarden)
        }
        return result
      }
    ) else {
      throw HTTPClientError.deserializationError
    }
    
    return friendGardens
  }
  
  public func delete(by id: ShareGardenSceneEntity.ShareGardenScene.FriendsGarden.ID) async throws {
    guard let requestBody = self.makeRequestBody(from: ["garden_id": id.uuidString]) else {
      throw NSError(domain: "Can not make DELETE request body", code: -1)
    }
    
    let request = HTTPRequest(
      method: HTTPMethod.post,
      endPoint: URLConstants.Garden.deleteGarden,
      body: requestBody
    )
    
    try await self.httpClient?.send(
      input: request,
      serializer: { $0 },
      deserializer: { response in
        guard response.statusCode == 204 else {
          throw HTTPClientError.badStatusCode(response.statusCode)
        }
      }
    )
  }
  
  public func requestMyGarden() async throws -> ShareGardenSceneEntity.ShareGardenScene.MyGarden {
    let request = HTTPRequest(method: HTTPMethod.get, endPoint: URLConstants.Garden.loadMyGarden)
    
    guard let myGarden = try await self.httpClient?.send(
      input: request,
      serializer: { $0 },
      deserializer: { response in
        try self.checkStatusCode(response: response)
        let decodedBody: [ShareGardenScene.MyGardenDTO] = try self.decodeBody(response: response)
        guard let myInfo = decodedBody.first else { throw HTTPClientError.deserializationError }
        
        let result = ShareGardenScene.MyGarden(
          nickname: myInfo.nickname,
          description: myInfo.introduction,
          pomodoroRecords: self.makePomodoroCollection(from: myInfo.pomodoroRecords)
        )
        return result
      }
    ) else {
      throw HTTPClientError.deserializationError
    }
    
    return myGarden
  }
}

extension ShareGardenSceneWorker {
  private func checkStatusCode(response: HTTPResponse) throws {
    guard response.statusCode >= 200 && response.statusCode < 400 else {
      throw HTTPClientError.badStatusCode(response.statusCode)
    }
  }
  
  private func decodeBody<T: Decodable>(response: HTTPResponse) throws -> T {
    guard let data = response.body else {
      throw HTTPClientError.deserializationError
    }
    
    return try JSONDecoder().decode(T.self, from: data)
  }
  
  public func makeRequestBody(from dictionary: [String: Any]) -> Data? {
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
      return jsonData
    } catch {
      return nil
    }
  }
}

import ToDoGardenUIComponent
extension ShareGardenSceneWorker {
  private func makePomodoroCollection(from userGardens: [ShareGardenScene.UserGardenDTO]?) -> PomodoroRecordCollection {
    guard let userGardens = userGardens else {
      return PomodoroRecordCollection()
    }
    
    var pomodoroRecords: [PomodoroRecord] = []
    for userGarden in userGardens {
      let pomodoro = PomodoroRecord(
        date: userGarden.date.toDateISO8601Format(),
        pomodoroCount: userGarden.pomodoroCount
      )
      pomodoroRecords.append(pomodoro)
    }
    let pomodoroCollection = PomodoroRecordCollection(pomodoroRecords: pomodoroRecords)
    return pomodoroCollection
  }
}
