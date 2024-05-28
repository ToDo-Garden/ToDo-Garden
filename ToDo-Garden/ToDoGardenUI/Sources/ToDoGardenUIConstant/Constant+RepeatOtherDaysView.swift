//
//  Constant+RepeatOtherDaysView.swift
//
//
//  Created by SONG on 5/28/24.
//

import Foundation

extension Constant.RepeatOtherDaysView {
  public enum Layout {}
  public enum StringLiteral {}
  public enum AboutAnimation {}
}

extension Constant.RepeatOtherDaysView.Layout {
  public static let heightUnselected: CGFloat = 31.0
  public static let heightSelected: CGFloat = 159.0
  
  public enum Title {
    public static let topMargin: CGFloat = 13.0
  }
  public enum InnerStackView {
    public static let width: CGFloat = 315.0
    public static let height: CGFloat = 119.0
  }
  public enum Divider {
    public static let width: CGFloat = 286.0
    public static let height: CGFloat = 1.0
  }
  public enum DateButtonSet {
    public static let width: CGFloat = 140.0
    public static let trailing: CGFloat = -17.0
    public static let buttonWidth: CGFloat = 93.0
    public static let margin: CGFloat = 3.0
  }
  
  public enum CommonMargin {
    public static let narrow: CGFloat = 10.0
    public static let broad: CGFloat = 40.0
  }
}

extension Constant.RepeatOtherDaysView.AboutAnimation {
  public static let duration: TimeInterval = 0.15
  public static let delay: UInt64 = UInt64(0.15)
  public static let alphaDisappear: CGFloat = 0.0
  public static let alphaAppear: CGFloat = 1.0
}

extension Constant.RepeatOtherDaysView.StringLiteral {
  public static let everyday: String = "매일"
  public static let timeSet: String = "시간지정"
}
