//
//  Constant+ToDoRepeatSelectionView.swift
//
//
//  Created by Wood on 5/14/24.
//

import Foundation

extension Constant.ToDoRepeatSelectionView {
  public enum Layout {}
  public enum StringLiteral {}
}

extension Constant.ToDoRepeatSelectionView.Layout {
  public enum RepetitionLabel {}
  public enum SelectionImageView {}
}

extension Constant.ToDoRepeatSelectionView.Layout {
  public static let cornerRadius: CGFloat = 15.5
}

extension Constant.ToDoRepeatSelectionView.Layout.RepetitionLabel {
  public static let topMargin: CGFloat = 7.5
  public static let leadingMargin: CGFloat = 16.0
}

extension Constant.ToDoRepeatSelectionView.Layout.SelectionImageView {
  public static let trailingMargin: CGFloat = 12.0
}

extension Constant.ToDoRepeatSelectionView.StringLiteral {
  public enum RepetitionLabel {}
}

extension Constant.ToDoRepeatSelectionView.StringLiteral.RepetitionLabel {
  public static let onlyToday: String = "오늘만 할래요"
  public static let anotherDay: String = "다른 날도 할래요"
}
