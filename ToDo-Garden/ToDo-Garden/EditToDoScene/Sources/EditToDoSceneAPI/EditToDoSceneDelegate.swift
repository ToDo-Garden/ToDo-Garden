//
//  File.swift
//  EditToDoScene
//
//  Created by Wood on 4/6/25.
//

import Foundation

import TDFoundation

@MainActor
public protocol EditToDoSceneDelegate: AnyObject {
  func didEdit(toDo: TodoBatchItem, isNeededDeletionBySelection: Bool)
  func didRemove(toDo: TodoBatchItem)
}
