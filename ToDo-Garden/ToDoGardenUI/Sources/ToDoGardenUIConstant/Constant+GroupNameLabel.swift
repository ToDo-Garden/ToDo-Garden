//
//  Constant+GroupNameLabel.swift
//
//
//  Created by Wood on 5/4/24.
//

import Foundation

extension Constant.GroupNameLabel {
  public enum Layout {}
}

extension Constant.GroupNameLabel.Layout {
  public enum TextPadding {}
}

extension Constant.GroupNameLabel.Layout {
  public static let cornerRadius: CGFloat = 11.5
}

extension Constant.GroupNameLabel.Layout.TextPadding {
  public static let top: CGFloat = 5
  public static let left: CGFloat = 11
  public static let bottom: CGFloat = 4
  public static let right: CGFloat = 11
}
