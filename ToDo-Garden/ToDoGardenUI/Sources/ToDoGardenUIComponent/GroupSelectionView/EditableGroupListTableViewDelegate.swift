//
//  EditableGroupTableViewDelegate.swift
//
//
//  Created by Wood on 7/9/24.
//

import UIKit

import ToDoGardenUIAPI
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

  func updateGroup(
    currentItem: any GroupSelectionViewItemAPI,
    editableItems: [any GroupSelectionViewItemAPI]
  ) {
    self.updateCurrentGroup(item: currentItem)
    let groupItems = self.makeEditableGroupItems(items: editableItems)
    self.storeEditableGroupIndex(groupItems: groupItems)
    self.reloadNewEditableGroups(groupItems: groupItems)
  }
}

// MARK: TableView Delegate Functions

extension EditableGroupTableViewDelegate: UITableViewDelegate {
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

extension EditableGroupTableViewDelegate {
  private func updateCurrentGroup(item: any GroupSelectionViewItemAPI) {
    let currentItem = EditableGroupItem(
      groupId: item.groupId,
      groupName: item.groupName,
      groupColor: item.groupColor
    )
    self.currentGroupItem = currentItem
  }

  private func makeEditableGroupItems(
    items: [any GroupSelectionViewItemAPI]
  ) -> [EditableGroupItem] {
    return items.map { (item: any GroupSelectionViewItemAPI) in
      return EditableGroupItem(
        groupId: item.groupId,
        groupName: item.groupName,
        groupColor: item.groupColor
      )
    }
  }

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
