//
//  ToDoListView+UIModel.swift
//  ToDoGardenUI
//
//  Created by Noah on 12/19/24.
//

import UIKit

extension ToDoListView {
  public struct ToDoSection: Hashable {
    public var id: UUID
    let headerUIModel: ToDoGroupUIModel
    public let toDoItems: [ToDoItem]
    
    public init(
      id: UUID = UUID(),
      headerUIModel: ToDoGroupUIModel,
      toDoItems: [ToDoItem]
    ) {
      self.id = id
      self.headerUIModel = headerUIModel
      self.toDoItems = toDoItems
    }
  }
  
  public struct ToDoItem: Hashable {
    public var id: UUID
    let toDoUIModel: ToDoUIModel
    
    public init(
      id: UUID = UUID(),
      toDoUIModel: ToDoUIModel
    ) {
      self.id = id
      self.toDoUIModel = toDoUIModel
    }
  }
  
  public struct ToDoGroupUIModel: Hashable {
    let progressColor: UIColor
    let progressRate: Double
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
  }
}
