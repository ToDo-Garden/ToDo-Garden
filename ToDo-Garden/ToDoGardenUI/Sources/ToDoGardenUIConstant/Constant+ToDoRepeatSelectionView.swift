//
//  Constant+ToDoRepeatSelectionView.swift
//
//
//  Created by Wood on 5/14/24.
//

import Foundation

extension Constant.ToDoRepeatSelectionView {
  public enum Layout {}
}

extension Constant.ToDoRepeatSelectionView.Layout {
  public enum RepetitionLabel {}
  public enum SelectionImageView {}
}

extension Constant.ToDoRepeatSelectionView.Layout.RepetitionLabel {
  public static let topMargin: CGFloat = 7.5
  public static let leadingMargin: CGFloat = 16.0
}

extension Constant.ToDoRepeatSelectionView.Layout.SelectionImageView {
  public static let trailingMargin: CGFloat = 12.0
}
