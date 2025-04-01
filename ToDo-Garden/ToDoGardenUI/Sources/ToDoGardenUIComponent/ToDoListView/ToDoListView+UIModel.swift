//
//  ToDoListView+UIModel.swift
//  ToDoGardenUI
//
//  Created by Noah on 12/19/24.
//

import UIKit

extension ToDoListView {
  public final class ToDoSection: Hashable, @unchecked Sendable {
    public let id: UUID
    let headerUIModel: ToDoGroupUIModel
    private(set) var toDoItems: [ToDoItem]
    
    public init(
      id: UUID = UUID(),
      headerUIModel: ToDoGroupUIModel,
      toDoItems: [ToDoItem]
    ) {
      self.id = id
      self.headerUIModel = headerUIModel
      self.toDoItems = toDoItems
    }
    
    public func getGroupTitle() -> String {
      return self.headerUIModel.groupTitle
    }
    
    public func getColor() -> UIColor {
      return self.headerUIModel.progressColor
    }
    
    public func getToDoItems() -> [ToDoItem] {
      return self.toDoItems
    }
    
    public func updateToDoItems(_ newToDoItems: [ToDoItem]) {
      self.toDoItems = newToDoItems
    }
    
    public func appendToDoItems(_ newToDoItem: ToDoItem) {
      self.toDoItems.append(newToDoItem)
    }
    
    public func removeToDoItems(at index: Int) {
      self.toDoItems.remove(at: index)
    }
    
    public static func == (lhs: ToDoSection, rhs: ToDoSection) -> Bool {
      return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
  }
  
  public final class ToDoItem: Hashable, @unchecked Sendable {
    public let id: UUID
    public let toDoUIModel: ToDoUIModel
    
    public init(
      id: UUID = UUID(),
      toDoUIModel: ToDoUIModel
    ) {
      self.id = id
      self.toDoUIModel = toDoUIModel
    }
    
    public static func == (lhs: ToDoItem, rhs: ToDoItem) -> Bool {
      return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
  }
  
  public final class ToDoGroupUIModel: Hashable, @unchecked Sendable {
    let progressColor: UIColor
    private(set) var progressRate: Double
    let groupTitle: String
    
    public init(
      progressColor: UIColor,
      progressRate: Double,
      groupTitle: String
    ) {
      self.progressColor = progressColor
      self.progressRate = progressRate
      self.groupTitle = groupTitle
    }
    
    public func updateProgressRate(_ newRate: Double) {
      self.progressRate = newRate
    }
    
    public static func == (lhs: ToDoGroupUIModel, rhs: ToDoGroupUIModel) -> Bool {
      return lhs.groupTitle == rhs.groupTitle &&
        lhs.progressRate == rhs.progressRate &&
        lhs.progressColor == rhs.progressColor
    }
    
    public func hash(into hasher: inout Hasher) {
      hasher.combine(groupTitle)
      hasher.combine(progressRate)
      hasher.combine(progressColor)
    }
  }
}
