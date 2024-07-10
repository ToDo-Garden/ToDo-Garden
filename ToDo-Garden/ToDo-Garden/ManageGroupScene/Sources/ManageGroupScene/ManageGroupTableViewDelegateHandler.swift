//
//  ManageGroupTableViewDelegateHandler.swift
//
//
//  Created by SONG on 7/9/24.
//

import UIKit

import ManageGroupSceneEntity
import ToDoGardenUIAPI

final class ManageGroupTableViewDelegateHandler: NSObject {
  
  // MARK: - Properties
  var displayedGroups: [ManageGroup.ToDoGroup]
  private let groupListTableView: ManageGroupTableViewAPI
  private let groupListTableViewCell: ManageGroupTableViewCellAPI
  private let footerView: UIView
  
  weak var viewController: ManageGroupViewController?
  
  init(
    displayedGroups: [ManageGroup.ToDoGroup],
    tableView: ManageGroupTableViewAPI,
    cell: ManageGroupTableViewCellAPI,
    footerView: UIView,
    viewController: ManageGroupViewController?
  ) {
    self.displayedGroups = displayedGroups
    self.groupListTableView = tableView
    self.groupListTableViewCell = cell
    self.footerView = footerView
    self.viewController = viewController
  }
}
