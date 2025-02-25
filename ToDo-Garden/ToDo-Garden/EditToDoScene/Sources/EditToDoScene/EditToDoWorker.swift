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

    return self.makeToDo(from: fetchedToDo)
  }

  public func fetchGroupList() async throws -> [EditToDo.Group] {
    let fetchedGroup = try await self.httpClient.send(
      input: EditToDo.FetchGroupList.RequestDTO(),
      serializer: { data in
        return HTTPRequest(
          method: .get,
          endPoint: URLConstants.Group.fetchGroups
        )
      },
      deserializer: { (response: HTTPResponse) in
        guard response.statusCode >= 200 && response.statusCode < 400 else {
          throw HTTPClientError.badStatusCode(response.statusCode)
        }

        guard let body = response.body else {
          throw HTTPClientError.deserializationError
        }

        return try JSONDecoder().decode(EditToDo.FetchGroupList.ResponseDTO.self, from: body)
      }
    )

    return fetchedGroup.data.map {
      return EditToDo.Group(id: $0.id, name: $0.name, color: $0.color, orderIdx: $0.orderIdx)
    }
  }

  public func editToDo(_ todo: EditToDo.ToDo) async throws {
    try await self.httpClient.send(
      input: self.makeEditRequest(todo: todo),
      serializer: { $0 },
      deserializer: { response in
        guard response.statusCode >= 200 && response.statusCode < 400 else {
          throw HTTPClientError.badStatusCode(response.statusCode)
        }
      }
    )
  }

  public func deleteToDo(id: UUID) async throws {
    
  }
}

extension EditToDoWorker {
  private func makeToDo(
    from fetchedToDo: EditToDo.FetchToDo.ResponseDTO
  ) -> EditToDo.ToDo {
    return EditToDo.ToDo(
      name: fetchedToDo.name,
      groupData: EditToDo.Group(
        id: fetchedToDo.group.id,
        name: fetchedToDo.group.name,
        color: fetchedToDo.group.color,
        orderIdx: fetchedToDo.group.orderIdx
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

  private func makeEditRequest(todo: EditToDo.ToDo) throws -> HTTPRequest {
    return HTTPRequest(
      method: HTTPMethod.patch,
      endPoint: URLConstants.ToDo.editToDo,
      body: try JSONEncoder().encode(
        EditToDo.CompleteEditToDo.RequestDTO(
          name: todo.name,
          isAlarmOn: todo.alarm.isAlarmOn,
          alarmTime: todo.alarm.alarmTime,
          isOnlyToday: todo.repetition.isOnlyToday,
          startDay: todo.repetition.startDate,
          endDay: todo.repetition.endDate,
          groupId: todo.groupData.id
        )
      )
    )
  }
}

// swiftlint: enable all
