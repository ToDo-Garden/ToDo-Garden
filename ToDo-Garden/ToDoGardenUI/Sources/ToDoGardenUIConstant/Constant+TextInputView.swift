//
//  Constant+TextInputView.swift
//
//
//  Created by Wood on 6/22/24.
//

import Foundation

extension Constant.TextInputView {
  public enum Animation {}
  public enum Layout {}
  public enum StringLiteral {}
}

extension Constant.TextInputView.Animation {
  public static let duration: CGFloat = 0.2
}

extension Constant.TextInputView.Layout {
  public enum PlaceholderLabel {}
  public enum InputTextField {}
}

extension Constant.TextInputView.Layout.PlaceholderLabel {
  public static let defaultHeight: CGFloat = 18
  public static let bottomMargin: CGFloat = 2
}

extension Constant.TextInputView.Layout.InputTextField {
  public static let defaultHeight: CGFloat = 20
}

extension Constant.TextInputView.StringLiteral {
  public static let placeholderText: String = "을 입력해주세요."
}
