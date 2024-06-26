//
//  Constant+PomodoroLevelCollectionView.swift
//
//
//  Created by Noah on 6/25/24.
//

import Foundation

extension Constant.PomodoroLevelCollectionView {
  public enum Layout { }
}

extension Constant.PomodoroLevelCollectionView.Layout {
  public enum Item { }
  public enum Group { }
}

extension Constant.PomodoroLevelCollectionView.Layout.Item {
  public static let widthFraction: CGFloat = 1.0
  public static let heightFraction: CGFloat = 1.0
}

extension Constant.PomodoroLevelCollectionView.Layout.Group {
  public static let widthFraction: CGFloat = 1.0
  public static let heightFraction: CGFloat = 1.0
  public static let interItemSpacing: CGFloat = 2.3
}
