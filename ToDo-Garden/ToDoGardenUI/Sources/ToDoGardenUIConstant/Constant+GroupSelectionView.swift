//
//  Constant+GroupSelectionView.swift
//
//
//  Created by Wood on 7/3/24.
//

import Foundation

extension Constant.GroupSelectionView {
  public enum Animation {}
  public enum Layout {}
  public enum Model {}
  public enum StringLiteral {}
}

extension Constant.GroupSelectionView.Animation {
  public static let duration: CGFloat = 0.2
}

extension Constant.GroupSelectionView.Layout {
  public enum TableViewContainer {}
  public enum EditableGroupTableView {}
  public enum EditableGroupTableViewCell {}
  public enum EditableGroupTableViewDelegate {}
}

extension Constant.GroupSelectionView.Layout.TableViewContainer {
  public enum Layer {}

  public static let topMargin: CGFloat = 14
  public static let leadingMargin: CGFloat = 10
  public static let trailingMargin: CGFloat = 5
}

extension Constant.GroupSelectionView.Layout.TableViewContainer.Layer {
  public static let shadowOpacity: Float = 0.15
  public static let shadowOffset = CGSize(width: 0, height: 2)
  public static let shadowRadius: CGFloat = 4
  public static let cornerRadius: CGFloat = 9
}

extension Constant.GroupSelectionView.Layout.EditableGroupTableView {
  public enum Layer {
    public static let cornerRadius: CGFloat = 9
  }
}

extension Constant.GroupSelectionView.Layout.EditableGroupTableViewCell {
  public enum SeparatorView {
    public static let width: CGFloat = 1.0
  }
}

extension Constant.GroupSelectionView.Layout.EditableGroupTableViewDelegate {
  public static let headerViewHeight: CGFloat = 2.0
}

extension Constant.GroupSelectionView.Model {
  public enum Primary {
    public static let cellHeight: CGFloat = 45
    public static let visibleCellCount = 3
  }
}

extension Constant.GroupSelectionView.StringLiteral {
  public static let defaultGroupName = "그룹 1"
}
