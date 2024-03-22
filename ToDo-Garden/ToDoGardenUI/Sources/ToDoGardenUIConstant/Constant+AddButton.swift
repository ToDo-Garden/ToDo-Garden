//
//  Constant+AddButton.swift
//
//
//  Created by Wood on 3/22/24.
//

import Foundation

extension Constant.AddUnderlinedTextButton {
  public enum Layout {}
  public enum Alpha {}
  public enum Title {}
}

extension Constant.AddUnderlinedTextButton.Layout {
  public static let imagePadding: CGFloat = 4.0
}

extension Constant.AddUnderlinedTextButton.Alpha {
  public static let highlighted: CGFloat = 0.7
}

extension Constant.AddUnderlinedTextButton.Title {
  public static let baselineOffset: CGFloat = 5.0
  public static let startPoint: CGFloat = 0
}
