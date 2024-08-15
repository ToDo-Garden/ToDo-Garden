//
//  GroupSelectionViewCell.swift
//
//
//  Created by Wood on 7/4/24.
//

import UIKit

import ToDoGardenUIConstant

final class GroupSelectionViewCell: UITableViewCell {
  private let editableGroupRow: Styled.Row

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    self.editableGroupRow = Styled.Row(
      configuration: Styled.Row.Configuration.listPrimary(
        Styled.Row.Configuration.ListPrimaryModel(
          title: Constant.GroupSelectionView.StringLiteral.defaultGroupName,
          color: UIColor.toDoGardenYellow
        )
      )
    )
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setup()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func updateUI(groupItem: GroupSelectionViewItem) {
    let groupName = groupItem.groupName
    let groupColor = groupItem.groupColor
    self.editableGroupRow.groupListModel = Styled.Row.Configuration.ListPrimaryModel(
      title: groupName,
      color: groupColor
    )
  }
}

// MARK: Private Functions

extension GroupSelectionViewCell {
  private func setup() {
    let separatorView = self.makeSeperatorView()
    self.addSubviews(with: separatorView)
    self.setupSubviewsLayout(with: separatorView)
  }

  private func makeSeperatorView() -> UIView {
    let separatorView = UIView()
    separatorView.backgroundColor = UIColor.toDoGardenGray1
    return separatorView
  }
}

// MARK: About Auto Layout

extension GroupSelectionViewCell {
  private func addSubviews(with separtorView: UIView) {
    self.contentView.addSubview(self.editableGroupRow)
    self.contentView.addSubview(separtorView)
  }

  private func setupSubviewsLayout(with separatorView: UIView) {
    self.setupEditableGroupRowLayout()
    self.setupSeparatorViewLayout(separatorView)
  }

  private func setupEditableGroupRowLayout() {
    self.editableGroupRow.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.editableGroupRow.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
        self.editableGroupRow.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        self.editableGroupRow.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
      ]
    )
  }

  private func setupSeparatorViewLayout(_ separatorView: UIView) {
    separatorView.usingAutolayout()

    let layout = Constant.GroupSelectionView.Layout.EditableGroupTableViewCell.SeparatorView.self
    NSLayoutConstraint.activate(
      [
        separatorView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        separatorView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
        separatorView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        separatorView.heightAnchor.constraint(equalToConstant: layout.width)
      ]
    )
  }
}

@available(iOS 17.0, *)
#Preview {
  let cell = GroupSelectionViewCell()
  cell.updateUI(
    groupItem: GroupSelectionViewItem(
      groupId: 0, groupName: "영어독해", groupColor: UIColor.toDoGardenGreenDark
    )
  )
  return cell
}
