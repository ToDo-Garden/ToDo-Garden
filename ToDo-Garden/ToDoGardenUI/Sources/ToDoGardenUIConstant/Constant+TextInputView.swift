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
  public static let duration: CGFloat = 0.4
  public static let shrinkScale: CGFloat = 0.8
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
  public static let bottomLineTopMargin: CGFloat = 5
}

extension Constant.TextInputView.StringLiteral {
  public static let defaultPlaceholderSuffix: String = "을(를) 입력해주세요."
  public static let suffixWithFinalConsonant: String = "을 입력해주세요."
  public static let suffixWithoutFinalConsonant: String = "를 입력해주세요."
}

extension Constant.TextInputView.StringLiteral {
  public enum Model {}
}

extension Constant.TextInputView.StringLiteral.Model {
  public static let toDoName = "할 일"
  public static let groupName = "그룹명"
  public static let userNickname = "닉네임"
  public static let userId = "아이디"
  public static let userDescription = "소개"
}
