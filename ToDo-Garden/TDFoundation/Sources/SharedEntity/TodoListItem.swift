//
//  TodoListItem.swift
//  TDFoundation
//
//  Created by Wood on 4/1/25.
//

// swiftlint:disable all
public final class TodoListItem: Codable, @unchecked Sendable {
  public var name: String
  public let endDay: String?
  public var isDone: Bool
  public let localID: String
  public let startDay: String?
  public let alarmTime: Int?
  public let isAlarmOn: Bool
  public let isOnlyToday: Bool
  public let repeatToDoId: String?

  enum CodingKeys: String, CodingKey {
    case name, endDay, isDone, startDay, alarmTime, isAlarmOn, isOnlyToday, repeatToDoId
    case localID = "local_id"
  }

  public init(name: String, endDay: String?, isDone: Bool, localID: String, startDay: String?, alarmTime: Int?, isAlarmOn: Bool, isOnlyToday: Bool, repeatToDoId: String?) {
    self.name = name
    self.endDay = endDay
    self.isDone = isDone
    self.localID = localID
    self.startDay = startDay
    self.alarmTime = alarmTime
    self.isAlarmOn = isAlarmOn
    self.isOnlyToday = isOnlyToday
    self.repeatToDoId = repeatToDoId
  }
}
// swiftlint:enable all
