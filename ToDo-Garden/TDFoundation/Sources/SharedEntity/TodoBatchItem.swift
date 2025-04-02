//
//  TodoBatchItem.swift
//  TDFoundation
//
//  Created by Wood on 4/1/25.
//

// swiftlint:disable all
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

  public init(localId: String, name: String, isDone: Bool, createdAt: String, isAlarmOn: Bool, alarmTime: Double, isOnlyToday: Bool, startDay: String?, endDay: String?, groupId: String, isDelete: Bool) {
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

  public func setPeriod(start: String, end: String) {
    self.isOnlyToday = false
    self.startDay = start
    self.endDay = end
  }
}
// swiftlint:enable all
