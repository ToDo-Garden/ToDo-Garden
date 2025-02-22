//
//  EditToDoWorker.swift
//
//
//  Created by Wood on 6/29/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation

import EditToDoSceneAPI
import EditToDoSceneEntity
import HTTPClientAPI
import TDFoundation
import TDUtility

public struct EditToDoWorker: EditToDoWorkable {
  private let httpClient: HTTPClientAPI

  public init(httpClient: HTTPClientAPI) {
    self.httpClient = httpClient
  }

  // swiftlint: disable all
  public func fetchToDo(id: UUID) async throws -> EditToDo.ToDo {
    let fetchedToDo = try await self.httpClient.send(
      input: EditToDo.FetchToDo.RequestDTO(id: id),
      serializer: { data in
        let request = HTTPRequest(
          method: .get,
          endPoint: URLConstants.ToDo.fetchToDoDetail,
          queryItems: ["todo_id": data.id.uuidString]
        )
        debugPrint(request)
        return request
      },
      deserializer: { (response: HTTPResponse) in
        guard response.statusCode >= 200 && response.statusCode < 400 else {
          throw HTTPClientError.badStatusCode(response.statusCode)
        }

        guard let body = response.body else {
          throw HTTPClientError.deserializationError
        }

        return try JSONDecoder().decode(EditToDo.FetchToDo.ResponseDTO.self, from: body)
      }
    )

    return EditToDo.ToDo(
      name: fetchedToDo.name,
      groupData: EditToDo.Group(
        id: fetchedToDo.group.id,
        name: fetchedToDo.group.name,
        color: fetchedToDo.group.color
      ),
      alarm: EditToDo.ToDoAlarm(
        isAlarmOn: fetchedToDo.isAlarmOn,
        alarmTime: fetchedToDo.alarmTime
      ),
      repetition: EditToDo.ToDoRepetition(
        isOnlyToday: fetchedToDo.isOnlyToday,
        startDate: fetchedToDo.startDate,
        endDate: fetchedToDo.endDate
      )
    )
  }

  public func fetchGroupList() async throws -> [EditToDo.Group] {
    return []
  }

  public func editToDo(id: UUID) async throws {

  }

  public func deleteToDo(id: UUID) async throws {

  }
}
// swiftlint: enable all
