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
    tableView.delegate = self
  }
}

// MARK: TableView Delegate Functions

extension EditableGroupTableViewDelegate: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return self.cellHeight
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = UIColor.toDoGardenGreenGray
    return headerView
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return Constant.GroupSelectionView.Layout.EditableGroupTableViewDelegate.headerViewHeight
  }
}
