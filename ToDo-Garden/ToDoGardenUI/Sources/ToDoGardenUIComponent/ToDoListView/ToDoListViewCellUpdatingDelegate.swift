//
//  ToDoListViewSelectionDelegate.swift
//  ToDoGardenUI
//
//  Created by SONG on 3/25/25.
//

import Foundation

@MainActor
public protocol ToDoListViewCellUpdatingDelegate: AnyObject {
  func updateSelection(isSelected: Bool, todo: ToDoListView.ToDoItem, at indexPath: IndexPath)
  func updateText(text: String, todo: ToDoListView.ToDoItem, at indexPath: IndexPath)
}
