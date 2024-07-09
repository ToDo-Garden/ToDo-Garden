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
  private var editableGroupIndexDictionary: [Int: Int]
  private var tableViewDataSource: UITableViewDiffableDataSource<
    EditableGroupSection,
    EditableGroupItem
  >!
  private(set) var currentGroupItem: EditableGroupItem? {
    willSet { self.selectedGroupSender?.send(groupItem: newValue) }
  }

  weak var selectedGroupSender: GroupDataSendable?

  init(tableView: UITableView, cellHeight: CGFloat) {
    self.cellHeight = cellHeight
    self.editableGroupIndexDictionary = [:]
    super.init()
    self.setupTableView(tableView)
  }

  func updateGroup(currentItem: EditableGroupItem, editableItems: [EditableGroupItem]) {
    self.currentGroupItem = currentItem
    self.storeEditableGroupIndex(groupItems: editableItems)
    self.reloadNewEditableGroups(groupItems: editableItems)
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

// MARK: Private Functions

extension EditableGroupTableViewDelegate {
  private func setupTableView(_ tableView: UITableView) {
    tableView.delegate = self
    self.tableViewDataSource = self.makeDiffableDataSource(tableView: tableView)
    tableView.dataSource = self.tableViewDataSource
  }

  private func makeDiffableDataSource(tableView: UITableView) -> UITableViewDiffableDataSource<
    EditableGroupSection,
    EditableGroupItem
  > {
    return UITableViewDiffableDataSource<
      EditableGroupSection,
      EditableGroupItem
    >(tableView: tableView) { (tableView, indexPath, itemIdentifier) in
      guard let cell = tableView.dequeueReusableCell(
        type: EditableGroupTableViewCell.self,
        for: indexPath
      ) else { return UITableViewCell() }

      cell.updateUI(groupItem: itemIdentifier)
      return cell
    }
  }

  private func storeEditableGroupIndex(groupItems: [EditableGroupItem]) {
    groupItems.enumerated().forEach { (index: Int, item: EditableGroupItem) in
      let id = item.groupId
      self.editableGroupIndexDictionary[id] = index
    }
  }

  private func reloadNewEditableGroups(groupItems: [EditableGroupItem]) {
    var snapshot = NSDiffableDataSourceSnapshot<EditableGroupSection, EditableGroupItem>()
    snapshot.appendSections([.main])
    let items = groupItems.filter { (item: EditableGroupItem) in
      if let currentGroupItem = self.currentGroupItem {
        return item != currentGroupItem
      }

      return false
    }
    snapshot.appendItems(items, toSection: EditableGroupSection.main)
    self.tableViewDataSource.apply(snapshot, animatingDifferences: true)
  }
}
