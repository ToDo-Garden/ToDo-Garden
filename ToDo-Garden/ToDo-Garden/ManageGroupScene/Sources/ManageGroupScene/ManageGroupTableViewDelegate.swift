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
  var displayedGroupsBeforeEditing: [ManageGroup.ToDoGroup]
  private let footerView: UIView
  
  private var onPostGroup: ((UUID, String, UIColor) -> Void)?
  private var onDeleteGroup: ((UUID, Int) -> Void)?
  private var onReorderingStateChange: ((Bool) -> Void)?
  
  private var isReordering: Bool = false {
    didSet {
      self.onReorderingStateChange?(isReordering)
    }
  }
  
  init(
    displayedGroups: [ManageGroup.ToDoGroup],
    footerView: UIView
  ) {
    self.displayedGroups = displayedGroups
    self.displayedGroupsBeforeEditing = displayedGroups
    self.footerView = footerView
  }
  
  func setOnPostGroup(_ handler: @escaping (UUID, String, UIColor) -> Void) {
    self.onPostGroup = handler
  }
  
  func setOnDeleteGroup(_ handler: @escaping (UUID, Int) -> Void) {
    self.onDeleteGroup = handler
  }
  
  func setOnReorderingStateChange(_ handler: @escaping (Bool) -> Void) {
    self.onReorderingStateChange = handler
  }
  
  func saveDisplayGroupsBeforeEditing() {
    self.displayedGroupsBeforeEditing = self.displayedGroups
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
    
    let singleGroup = self.displayedGroups[indexPath.row]
    
    cell.applyModelPrimary(
      id: singleGroup.groupID,
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
    cell.setupRightButtonAction { [weak self] groupID, groupName, groupColor in
      self?.onPostGroup?(groupID, groupName, groupColor)
    }
    return cell
  }
}

// MARK: - UITableViewDelegate
extension ManageGroupTableViewDelegate: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath
  ) {
    guard !isReordering else { return }
    
    let index = indexPath.row
    let groupID = self.displayedGroups[index].groupID
    
    if editingStyle == UITableViewCell.EditingStyle.delete {
      self.onDeleteGroup?(groupID, index)
    }
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return tableView.isEditing
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return self.footerView
  }
}

// MARK: - UITableViewDragDelegate
extension ManageGroupTableViewDelegate: UITableViewDragDelegate {
  func tableView(_ tableView: UITableView, dragSessionWillBegin session: UIDragSession) {
    self.isReordering = true
  }
  
  func tableView(_ tableView: UITableView, dragSessionDidEnd session: UIDragSession) {
    self.isReordering = false
  }
  
  func tableView(_ tableView: UITableView, dragSessionAllowsMoveOperation session: UIDragSession) -> Bool {
    return tableView.isEditing
  }
  
  func tableView(
    _ tableView: UITableView,
    itemsForBeginning session: UIDragSession,
    at indexPath: IndexPath
  ) -> [UIDragItem] {
    let item = displayedGroups[indexPath.row]
    let itemProvider = NSItemProvider(object: item.groupID.uuidString as NSString)
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
    }
  }
}
