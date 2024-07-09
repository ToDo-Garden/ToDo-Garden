//
//  GroupSelectionView.swift
//
//
//  Created by Wood on 7/9/24.
//

import UIKit

import ToDoGardenUIConstant

public final class GroupSelectionView: UIView {
  private let model: GroupSelectionView.Model
  private let showGroupListButton: UIButton
  private let currentGroupRow: Styled.Row

  public init(model: GroupSelectionView.Model) {
    self.model = model
    self.showGroupListButton = UIButton()
    self.currentGroupRow = Styled.Row(
      configuration: Styled.Row.Configuration.listPrimary(
        Styled.Row.Configuration.ListPrimaryModel(
          title: Constant.GroupSelectionView.StringLiteral.defaultGroupName,
          color: UIColor.toDoGardenYellow
        )
      )
    )
    super.init(frame: CGRect.zero)
    self.setup()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Private Functions

extension GroupSelectionView {
  private func setup() {
    self.addSubviews()
    self.setupSubviewsLayout()
  }
}

// MARK: About Auto Layout

extension GroupSelectionView {
  private func addSubviews() {
    self.addSubview(self.currentGroupRow)
  }

  private func setupSubviewsLayout() {
    self.setupCurrentGroupRowLayout()
  }

  private func setupCurrentGroupRowLayout() {
    self.currentGroupRow.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.currentGroupRow.topAnchor.constraint(equalTo: self.topAnchor),
        self.currentGroupRow.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        self.currentGroupRow.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        self.currentGroupRow.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor)
      ]
    )
  }
}

// MARK: Model

extension GroupSelectionView {
  public struct Model {
    let cellHeight: CGFloat
    let visibleCellCount: Int

    init(cellHeight: CGFloat, visibleCellCount: Int) {
      self.cellHeight = cellHeight
      self.visibleCellCount = visibleCellCount
    }

    public static let primary = Self(
      cellHeight: Constant.GroupSelectionView.Model.Primary.cellHeight,
      visibleCellCount: Constant.GroupSelectionView.Model.Primary.visibleCellCount
    )
  }
}
