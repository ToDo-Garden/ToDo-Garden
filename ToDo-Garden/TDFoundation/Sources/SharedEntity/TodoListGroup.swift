//
//  TodoListGroup.swift
//  TDFoundation
//
//  Created by Wood on 4/1/25.
//

public final class TodoListGroup: Codable, @unchecked Sendable {
  public let localId: String
  public let name: String
  public let color: String
  public var todoList: [TodoListItem]?
  public let progressRate: Double

  public init(localId: String, name: String, color: String, todoList: [TodoListItem]?, progressRate: Double) {
    self.localId = localId
    self.name = name
    self.color = color
    self.todoList = todoList
    self.progressRate = progressRate
  }
}
