//
//  Constant+CalendarView.swift
//
//
//  Created by Wood on 5/31/24.
//

import Foundation

extension Constant.CalendarView {
  public enum Animation {}
  public enum Layout {}
  public enum Model {}
  public enum StringLiteral {}
}

extension Constant.CalendarView.Animation {
  public static let duration: CGFloat = 0.1
}

extension Constant.CalendarView.Layout {
  public enum MonthLabel {
    public static let topMargin: CGFloat = 12
    public static let leadingMargin: CGFloat = 12
  }

  public enum BackButton {
    public static let trailingMargin: CGFloat = 12
    public static let widthMargin: CGFloat = 24
    public static let heightMargin: CGFloat = 24
  }

  public enum ForwardButton {
    public static let trailingMargin: CGFloat = 6
    public static let widthMargin: CGFloat = 24
    public static let heightMargin: CGFloat = 24
  }

  public enum WeekdaySymbolStackView {
    public static let topMargin: CGFloat = 26
    public static let leadingMargin: CGFloat = 22
    public static let trailingMargin: CGFloat = 19
  }

  public enum CollectionView {
    public static let topMargin: CGFloat = 15
    public static let leadingMargin: CGFloat = 13
    public static let trailingMargin: CGFloat = 10
    public static let bottomMargin: CGFloat = 11
    public static let defaultHeight: CGFloat = 98
  }

  public enum CollectionViewCell {
    public static let cornerRadius: CGFloat = 5
  }
}

extension Constant.CalendarView.Layout.CollectionViewCell {
  public enum ToDoExistenceView {
    public static let cornerRadius: CGFloat = 1
    public static let widthMargin: CGFloat = 2
    public static let heightMargin: CGFloat = 2
  }
}

extension Constant.CalendarView.Model {
  public enum Primary {}
}

extension Constant.CalendarView.Model.Primary {
  public static let cornerRadius: CGFloat = 10
  public static let borderWidth: CGFloat = 1
  public static let itemSize = CGSize(width: 30, height: 30)
  public static let itemSpacing: CGFloat = 15
  public static let lineSpacing: CGFloat = 8
}

extension Constant.CalendarView.StringLiteral {
  public static let dateFormat = "yyyy년 MMM d"
}
