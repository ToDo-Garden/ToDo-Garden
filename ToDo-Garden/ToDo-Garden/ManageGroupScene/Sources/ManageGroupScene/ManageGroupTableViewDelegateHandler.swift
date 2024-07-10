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
    return self.displayedGroups.count
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

// MARK: - UITableViewDragDelegate
extension ManageGroupTableViewDelegateHandler: UITableViewDragDelegate {
  func tableView(_ tableView: UITableView, dragSessionAllowsMoveOperation session: UIDragSession) -> Bool {
    return tableView.isEditing
  }
  
  func tableView(
    _ tableView: UITableView,
    itemsForBeginning session: UIDragSession,
    at indexPath: IndexPath
  ) -> [UIDragItem] {
    let item = displayedGroups[indexPath.row]
    let itemProvider = NSItemProvider(object: item.id as NSString)
    return [UIDragItem(itemProvider: itemProvider)]
  }
}

// MARK: - UITableViewDropDelegate
extension ManageGroupTableViewDelegateHandler: UITableViewDropDelegate {
  func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
    
    if coordinator.proposal.operation == UIDropOperation.move {
      self.reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath)
    }
  }
  
  func tableView(
    _ tableView: UITableView,
    dropSessionDidUpdate session: UIDropSession,
    withDestinationIndexPath destinationIndexPath: IndexPath?
  ) -> UITableViewDropProposal {
    if session.localDragSession != nil {
      return UITableViewDropProposal(
        operation: UIDropOperation.move,
        intent: UITableViewDropProposal.Intent.insertAtDestinationIndexPath
      )
    } else {
      return UITableViewDropProposal(operation: UIDropOperation.cancel)
    }
  }
  
  private func reorderItems(coordinator: UITableViewDropCoordinator, destinationIndexPath: IndexPath) {
    guard let tableView = self.groupListTableView as? UITableView else {
      return
    }
    
    if let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath {
      tableView.performBatchUpdates({
        let movedItem = displayedGroups.remove(at: sourceIndexPath.row)
        displayedGroups.insert(movedItem, at: destinationIndexPath.row)
        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
      }, completion: nil)
      coordinator.drop(item.dragItem, toRowAt: destinationIndexPath)
      
      let id = displayedGroups[sourceIndexPath.row].id
      self.viewController?.addReorderedGroups(
        id: id,
        sourceIndex: sourceIndexPath.row,
        destinationIndex: destinationIndexPath.row
      )
    }
  }
}
