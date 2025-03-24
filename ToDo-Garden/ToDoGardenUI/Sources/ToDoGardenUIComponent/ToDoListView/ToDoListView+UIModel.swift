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
    private var _toDoItems: [ToDoItem]
    private let lock = NSLock()
    
    public var toDoItems: [ToDoItem] {
      get {
        self.lock.lock()
        defer { self.lock.unlock() }
        return self._toDoItems
      }
      set {
        self.lock.lock()
        self._toDoItems = newValue
        self.lock.unlock()
      }
    }
    
    public init(
      id: UUID = UUID(),
      headerUIModel: ToDoGroupUIModel,
      toDoItems: [ToDoItem]
    ) {
      self.id = id
      self.headerUIModel = headerUIModel
      self._toDoItems = toDoItems
    }
    
    public func getGroupTitle() -> String {
      return self.headerUIModel.groupTitle
    }
    
    public func getColor() -> UIColor {
      return self.headerUIModel.progressColor
    }
    
    public static func == (lhs: ToDoSection, rhs: ToDoSection) -> Bool {
      return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
  }
  
  public class ToDoItem: Hashable, @unchecked Sendable {
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
    private var _progressRate: Double
    private let lock = NSLock()
    let groupTitle: String
    
    public var progressRate: Double {
      get {
        self.lock.lock()
        defer { self.lock.unlock() }
        return self._progressRate
      }
      set {
        self.lock.lock()
        self._progressRate = newValue
        self.lock.unlock()
      }
    }
    
    public init(
      progressColor: UIColor,
      progressRate: Double,
      groupTitle: String
    ) {
      self.progressColor = progressColor
      self._progressRate = progressRate
      self.groupTitle = groupTitle
    }
    
    public static func == (lhs: ToDoGroupUIModel, rhs: ToDoGroupUIModel) -> Bool {
      return lhs.groupTitle == rhs.groupTitle && lhs.progressRate == rhs.progressRate && lhs.progressColor == rhs.progressColor
    }
    
    public func hash(into hasher: inout Hasher) {
      hasher.combine(groupTitle)
      hasher.combine(progressRate)
      hasher.combine(progressColor)
    }
  }
}
