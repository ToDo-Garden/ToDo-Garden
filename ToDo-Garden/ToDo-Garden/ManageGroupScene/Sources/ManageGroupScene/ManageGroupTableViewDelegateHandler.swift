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

// MARK: - UITableViewDataSource
extension ManageGroupTableViewDelegateHandler: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return displayedGroups.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Constant.Layout.Cell.height
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return Constant.Layout.FooterView.height
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: self.groupListTableViewCell.getIdentifier(),
      for: indexPath
    ) as? ManageGroupTableViewCellAPI else {
      return UITableViewCell()
    }
    
    let singleGroup = displayedGroups[indexPath.row]
    
    cell.applyModelPrimary(
      id: singleGroup.id,
      groupName: singleGroup.groupName,
      progressColor: singleGroup.progressColor,
      progressRate: singleGroup.progressRate,
      isEditing: tableView.isEditing
    )
    
    if tableView.isEditing {
      cell.enterEditingMode()
    } else {
      cell.leaveEditingMode()
    }
    
    cell.setupRightButtonAction { color, name in
      self.viewController?.routeToPostGroupScene(groupName: name, color: color)
    }
    
    return cell as? UITableViewCell ?? UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return self.footerView
  }
}

// MARK: - UITableViewDelegate
extension ManageGroupTableViewDelegateHandler: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath
  ) {
    let index = indexPath.row
    let id = displayedGroups[index].id
    
    if editingStyle == UITableViewCell.EditingStyle.delete {
      self.viewController?.deleteGroup(id: id, index: index)
    }
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return tableView.isEditing
  }
}
