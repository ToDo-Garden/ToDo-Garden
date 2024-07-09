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

  public init(model: GroupSelectionView.Model) {
    self.model = model
    super.init(frame: CGRect.zero)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

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
