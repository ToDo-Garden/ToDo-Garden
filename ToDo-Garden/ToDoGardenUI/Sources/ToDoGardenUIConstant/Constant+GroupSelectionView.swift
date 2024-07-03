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
  public enum Layer {}

  public static let topMargin: CGFloat = 6
  public static let leadingMargin: CGFloat = 10
  public static let trailingMargin: CGFloat = 5
}

extension Constant.GroupSelectionView.Layout.TableViewContainer.Layer {
  public static let shadowOpacity: Float = 0.15
  public static let shadowOffset = CGSize(width: 0, height: 2)
  public static let shadowRadius: CGFloat = 4
  public static let cornerRadius: CGFloat = 9
}
