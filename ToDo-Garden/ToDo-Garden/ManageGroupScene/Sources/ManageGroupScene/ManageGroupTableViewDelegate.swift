//
//  ManageGroupTableViewDelegate.swift
//
//
//  Created by SONG on 7/9/24.
//

import UIKit

import ManageGroupSceneEntity
import ToDoGardenUIComponent

final class ManageGroupTableViewDelegate: NSObject {
  
  // MARK: - Properties
  var displayedGroups: [ManageGroup.ToDoGroup]
  private let footerView: UIView
  
  private var onPostGroup: ((String, UIColor) -> Void)?
  private var onReorderGroups: ((String, Int, Int) -> Void)?
  private var onDeleteGroup: ((String, Int) -> Void)?
  
  init(
    displayedGroups: [ManageGroup.ToDoGroup],
    footerView: UIView
  ) {
    self.displayedGroups = displayedGroups
    self.footerView = footerView
  }
  
  func setOnPostGroup(_ handler: @escaping (String, UIColor) -> Void) {
    self.onPostGroup = handler
  }
  
  func setOnReorderGroups(_ handler: @escaping (String, Int, Int) -> Void) {
    self.onReorderGroups = handler
  }
  
  func setOnDeleteGroup(_ handler: @escaping (String, Int) -> Void) {
    self.onDeleteGroup = handler
  }
}

// MARK: - UITableViewDataSource
extension ManageGroupTableViewDelegate: UITableViewDataSource {
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
      withIdentifier: ManageGroupTableViewCell.identifier,
      for: indexPath
    ) as? ManageGroupTableViewCell else {
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
    cell.setupRightButtonAction { [weak self] color, name in
      self?.onPostGroup?(name, color)
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return self.footerView
  }
}

// MARK: - UITableViewDelegate
extension ManageGroupTableViewDelegate: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath
  ) {
    let index = indexPath.row
    let id = self.displayedGroups[index].id
    
    if editingStyle == UITableViewCell.EditingStyle.delete {
      self.onDeleteGroup?(id, index)
    }
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return tableView.isEditing
  }
}

// MARK: - UITableViewDragDelegate
extension ManageGroupTableViewDelegate: UITableViewDragDelegate {
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
extension ManageGroupTableViewDelegate: UITableViewDropDelegate {
  func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
    
    if coordinator.proposal.operation == UIDropOperation.move {
      self.reorderItems(
        tableView: tableView,
        coordinator: coordinator,
        destinationIndexPath: destinationIndexPath
      )
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
  
  private func reorderItems(
    tableView: UITableView,
    coordinator: UITableViewDropCoordinator,
    destinationIndexPath: IndexPath
  ) {
    if let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath {
      tableView.performBatchUpdates({
        let movedItem = self.displayedGroups.remove(at: sourceIndexPath.row)
        self.displayedGroups.insert(movedItem, at: destinationIndexPath.row)
        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
      }, completion: nil)
      coordinator.drop(item.dragItem, toRowAt: destinationIndexPath)
      
      let id = self.displayedGroups[sourceIndexPath.row].id
      self.onReorderGroups?(id, sourceIndexPath.row, destinationIndexPath.row)
    }
  }
}
