//
//  GroupSelectionTableViewCell.swift
//
//
//  Created by Wood on 7/4/24.
//

import UIKit

import ToDoGardenUIConstant

final class GroupSelectionTableViewCell: UITableViewCell {
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
}

// MARK: Private Functions

extension GroupSelectionTableViewCell {
  private func setup() {
    self.addEditableGroupRow()
    self.setupEditableGroupRowLayout()
  }
}

// MARK: About Auto Layout

extension GroupSelectionTableViewCell {
  private func addEditableGroupRow() {
    self.contentView.addSubview(self.editableGroupRow)
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
}
