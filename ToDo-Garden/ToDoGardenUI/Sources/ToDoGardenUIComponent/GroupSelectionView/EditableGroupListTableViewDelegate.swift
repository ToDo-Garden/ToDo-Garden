//
//  EditableGroupTableViewDelegate.swift
//
//
//  Created by Wood on 7/9/24.
//

import UIKit

import ToDoGardenUIConstant

final class EditableGroupTableViewDelegate: NSObject {
  private let cellHeight: CGFloat

  init(tableView: UITableView, cellHeight: CGFloat) {
    self.cellHeight = cellHeight
    super.init()
  }
}
