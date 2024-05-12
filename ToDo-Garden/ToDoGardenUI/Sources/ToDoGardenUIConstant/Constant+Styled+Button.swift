//
//  Constant+Styled+Button.swift
//
//
//  Created by Wood on 5/12/24.
//

import Foundation

extension Constant.Styled {
  public enum Button {}
}

extension Constant.Styled.Button {
  public enum OnlyToday {}
}

// MARK: Only Today

extension Constant.Styled.Button.OnlyToday {
  public enum Layout {}
}

extension Constant.Styled.Button.OnlyToday.Layout {
  public enum ImageView {}
  public enum TitleLabel {}
}

extension Constant.Styled.Button.OnlyToday.Layout.ImageView {
  static let trailingMargin: CGFloat = 12
}

extension Constant.Styled.Button.OnlyToday.Layout.TitleLabel {
  static let leadingMargin: CGFloat = 16
}
