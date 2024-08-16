//
//  GroupSelectionViewSection+Item.swift
//
//
//  Created by Wood on 7/3/24.
//

import UIKit.UIColor

import ToDoGardenUIAPI

enum GroupSelectionViewSection {
  case main
}

public struct GroupSelectionViewItem {
  public let groupId: Int
  public let groupName: String
  public let groupColor: UIColor

  public init(groupId: Int, groupName: String, groupColor: UIColor) {
    self.groupId = groupId
    self.groupName = groupName
    self.groupColor = groupColor
  }
}

extension GroupSelectionViewItem: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.groupId)
  }
}

extension GroupSelectionViewItem: Comparable {
  public static func < (lhs: GroupSelectionViewItem, rhs: GroupSelectionViewItem) -> Bool {
    return lhs.groupId > rhs.groupId
  }
}
