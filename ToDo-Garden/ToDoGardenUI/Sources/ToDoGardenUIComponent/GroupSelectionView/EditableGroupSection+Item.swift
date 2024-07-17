//
//  EditableGroupSection+Item.swift
//
//
//  Created by Wood on 7/3/24.
//

import UIKit.UIColor

import ToDoGardenUIAPI

enum EditableGroupSection {
  case main
}

public struct EditableGroupItem: GroupSelectionViewItemAPI {
  public let groupId: Int
  public let groupName: String
  public let groupColor: UIColor

  public init(groupId: Int, groupName: String, groupColor: UIColor) {
    self.groupId = groupId
    self.groupName = groupName
    self.groupColor = groupColor
  }
}

extension EditableGroupItem: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.groupId)
  }
}

extension EditableGroupItem: Comparable {
  public static func < (lhs: EditableGroupItem, rhs: EditableGroupItem) -> Bool {
    return lhs.groupId > rhs.groupId
  }
}
