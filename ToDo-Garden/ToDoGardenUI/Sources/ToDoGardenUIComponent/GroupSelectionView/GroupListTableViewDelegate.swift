//
//  GroupListTableViewDelegate.swift
//
//
//  Created by Wood on 7/9/24.
//

import UIKit

import ToDoGardenUIAPI
import ToDoGardenUIConstant

final class GroupListTableViewDelegate: NSObject {
  private let cellHeight: CGFloat
  private var editableGroupIndexDictionary: [Int: Int]
  private var tableViewDataSource: UITableViewDiffableDataSource<
    EditableGroupSection,
    EditableGroupItem
  >!
  private(set) var currentGroupItem: EditableGroupItem? {
    willSet { self.groupListSelectionDelegate?.send(groupItem: newValue) }
  }

  weak var groupListSelectionDelegate: GroupListSelectionDelegate?

  init(tableView: UITableView, cellHeight: CGFloat) {
    self.cellHeight = cellHeight
    self.editableGroupIndexDictionary = [:]
    super.init()
    self.setupTableView(tableView)
  }

  func updateGroup(
    currentItem: EditableGroupItem,
    editableItems: [EditableGroupItem]
  ) {
    self.currentGroupItem = currentItem
    self.storeEditableGroupIndex(groupItems: editableItems)
    self.reloadNewEditableGroups(groupItems: editableItems)
  }
}

protocol GroupListSelectionDelegate: AnyObject {
  func send(groupItem: EditableGroupItem?)
}

// MARK: TableView Delegate Functions

extension GroupListTableViewDelegate: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return self.cellHeight
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let newItem = self.tableViewDataSource.itemIdentifier(for: indexPath)
    else { return }

    let oldItem = self.currentGroupItem
    self.currentGroupItem = newItem

    var snapshot = insertInCorrectOrder(oldItem: oldItem)
    snapshot.deleteItems([newItem])
    self.tableViewDataSource.apply(snapshot, animatingDifferences: true)
  }

  private func insertInCorrectOrder(oldItem: EditableGroupItem?) ->
  NSDiffableDataSourceSnapshot<EditableGroupSection, EditableGroupItem> {
    var snapshot = self.tableViewDataSource.snapshot()
    guard let oldItem = oldItem
    else { return snapshot }

    let items = snapshot.itemIdentifiers
    if let index = self.editableGroupIndexDictionary[oldItem.groupId] {
      if index == 0 {
        let beforeItem = items[0]
        snapshot.insertItems([oldItem], beforeItem: beforeItem)
      } else {
        let afterItem = items[index - 1]
        snapshot.insertItems([oldItem], afterItem: afterItem)
      }
    }

    return snapshot
  }
}

// MARK: Private Functions

extension GroupListTableViewDelegate {
  private func setupTableView(_ tableView: UITableView) {
    tableView.delegate = self
    self.tableViewDataSource = self.makeDiffableDataSource(tableView: tableView)
    self.tableViewDataSource.defaultRowAnimation = UITableView.RowAnimation.right
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
