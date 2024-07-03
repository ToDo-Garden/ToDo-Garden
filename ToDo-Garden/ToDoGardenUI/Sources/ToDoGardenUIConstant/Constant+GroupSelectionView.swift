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
}

extension Constant.GroupSelectionView.Animation {
  public static let duration: CGFloat = 0.2
}

extension Constant.GroupSelectionView.Layout {
  public enum TableViewContainer {}
}

extension Constant.GroupSelectionView.Layout.TableViewContainer {
  public static let topMargin: CGFloat = 6
  public static let leadingMargin: CGFloat = 10
  public static let trailingMargin: CGFloat = 5
}
