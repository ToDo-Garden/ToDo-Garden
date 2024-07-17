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

struct EditableGroupItem: GroupSelectionViewItemAPI {
  let groupId: Int
  let groupName: String
  let groupColor: UIColor
}

extension EditableGroupItem: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.groupId)
  }
}

extension EditableGroupItem: Comparable {
  static func < (lhs: EditableGroupItem, rhs: EditableGroupItem) -> Bool {
    return lhs.groupId > rhs.groupId
  }
}
