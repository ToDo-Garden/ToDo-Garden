//
//  Schema+ToDoList.swift
//  TDFoundation
//
//  Created by SONG on 3/31/25.
//

import Foundation

import HTTPClientAPI
import SharedEntity
import SharingGRDB

// swiftlint: disable line_length
// MARK: TABLE MODELS
public struct MyGroup: Codable, FetchableRecord, MutablePersistableRecord, Sendable {
  public static let databaseTableName = "MyGroups"
  
  public let groupId: String
  public let date: String
  public var name: String
  public var color: String
  
  public init(groupId: String, date: String, name: String, color: String) {
    self.groupId = groupId
    self.date = date
    self.name = name
    self.color = color
  }
}

public struct MyToDo: Codable, FetchableRecord, MutablePersistableRecord, Sendable {
  public static let databaseTableName = "MyToDos"
  
  public let todoId: String
  public let groupId: String
  public let date: String
  public let name: String
  public let isDone: Bool
  public let startDay: String?
  public let endDay: String?
  public let alarmTime: Int?
  public let isAlarmOn: Bool
  public let isOnlyToday: Bool
  public let repeatToDoId: String?
  
  public init(todoId: String, groupId: String, date: String, name: String, isDone: Bool, startDay: String?, endDay: String?, alarmTime: Int?, isAlarmOn: Bool, isOnlyToday: Bool, repeatToDoId: String?) {
    self.todoId = todoId
    self.groupId = groupId
    self.date = date
    self.name = name
    self.isDone = isDone
    self.startDay = startDay
    self.endDay = endDay
    self.alarmTime = alarmTime
    self.isAlarmOn = isAlarmOn
    self.isOnlyToday = isOnlyToday
    self.repeatToDoId = repeatToDoId
  }
}

// MARK: JSON DTO
public struct DailyToDoListData: Codable, Sendable {
  public let date: String
  public let list: [TodoListGroup]
  
  public init(date: String, list: [TodoListGroup]) {
    self.date = date
    self.list = list
  }
}

public final class TodoBatchItem: Codable, @unchecked Sendable {
  public let localId: String
  public var name: String
  public var isDone: Bool
  public let createdAt: String
  public var isAlarmOn: Bool
  public var alarmTime: Double
  public var isOnlyToday: Bool
  public var startDay: String?
  public var endDay: String?
  public let groupId: String
  public var isDelete: Bool
  public let repeatToDoId: String?
  
  public init(localId: String, name: String, isDone: Bool, createdAt: String, isAlarmOn: Bool, alarmTime: Double, isOnlyToday: Bool, startDay: String?, endDay: String?, groupId: String, isDelete: Bool, repeatToDoId: String? = nil) {
    self.localId = localId
    self.name = name
    self.isDone = isDone
    self.createdAt = createdAt
    self.isAlarmOn = isAlarmOn
    self.alarmTime = alarmTime
    self.isOnlyToday = isOnlyToday
    self.startDay = startDay
    self.endDay = endDay
    self.groupId = groupId
    self.isDelete = isDelete
    self.repeatToDoId = repeatToDoId
  }

  public func setDelete(_ isDelete: Bool) {
    self.isDelete = isDelete
  }

  public func setDone(_ isDone: Bool) {
    self.isDone = isDone
  }

  public func setName(_ newName: String) {
    self.name = newName
  }

  public func setAlarm(isOn: Bool, time: Double) {
    self.isAlarmOn = isOn
    self.alarmTime = time
  }

  public func setPeriod(start: String?, end: String?) {
    self.isOnlyToday = false
    self.startDay = start
    self.endDay = end
  }

  public func setOnlyToday() {
    self.isOnlyToday = true
    self.startDay = nil
    self.endDay = nil
  }
}

extension TodoBatchItem: FetchableRecord, MutablePersistableRecord {
  public static let databaseTableName: String = "todoBatchItem"
  
  public func convertToMyToDo() -> MyToDo? {
    guard !self.isDelete else { return nil }
    
    return MyToDo(
      todoId: self.localId,
      groupId: self.groupId,
      date: self.createdAt.toYYYYMMDDStringFromISO8601(),
      name: self.name,
      isDone: self.isDone,
      startDay: self.isOnlyToday ? nil : self.startDay,
      endDay: self.isOnlyToday ? nil : self.endDay,
      alarmTime: self.isAlarmOn ? Int(self.alarmTime) : nil,
      isAlarmOn: self.isAlarmOn,
      isOnlyToday: self.isOnlyToday,
      repeatToDoId: nil
    )
  }
}

public struct PendingEditGroup: Codable, FetchableRecord, MutablePersistableRecord {
  public static let databaseTableName: String = "pendingEditGroup"
  
  var requestData: Data
  
  public init(request: HTTPRequest) throws {
    self.requestData = try JSONEncoder().encode(request)
  }
  
  public func toHTTPRequest() throws -> HTTPRequest {
    return try JSONDecoder().decode(HTTPRequest.self, from: requestData)
  }
}
// swiftlint: enable line_length
