//
//  Constant+PomodoroRecordCollectionView.swift
//
//
//  Created by Noah on 6/25/24.
//

import Foundation

extension Constant.PomodoroRecordCollectionView {
  public enum Layout { }
}

extension Constant.PomodoroRecordCollectionView.Layout {
  public enum Item { }
  public enum Group { }
}

extension Constant.PomodoroRecordCollectionView.Layout.Item {
  public static let widthFraction: CGFloat = 1.0 / 20.0
  public static let heightFraction: CGFloat = 1.0
}

extension Constant.PomodoroRecordCollectionView.Layout.Group {
  public static let widthFraction: CGFloat = 1.0
  public static let heightFraction: CGFloat = 1.0
  public static let interItemSpacing: CGFloat = 5.33
}
