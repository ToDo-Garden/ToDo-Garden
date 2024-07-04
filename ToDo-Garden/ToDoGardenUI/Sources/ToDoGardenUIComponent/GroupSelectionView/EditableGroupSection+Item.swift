//
//  EditableGroupSection+Item.swift
//
//
//  Created by Wood on 7/3/24.
//

import UIKit.UIColor

enum EditableGroupSection {
  case main
}

public struct EditableGroupItem {
  let groupId: Int
  let groupName: String
  let groupColor: UIColor

  public init(
    groupId: Int,
    groupName: String,
    groupColor: UIColor
  ) {
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
