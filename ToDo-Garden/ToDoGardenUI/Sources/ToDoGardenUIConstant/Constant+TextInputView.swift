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
  public enum UserID {}
  public enum UserName {}
  public enum GroupName {}
  public enum ToDoName {}
  public enum UserIntroduction {}
}

extension Constant.TextInputView.StringLiteral.UserID {
  public static let inputText = "아이디"
  public static let placeholderText = "아이디를 입력해주세요."
}

extension Constant.TextInputView.StringLiteral.UserName {
  public static let inputText = "닉네임"
  public static let placeholderText = "닉네임을 입력해주세요."
}

extension Constant.TextInputView.StringLiteral.GroupName {
  public static let inputText = "그룹명"
  public static let placeholderText = "그룹명을 입력해주세요."
}

extension Constant.TextInputView.StringLiteral.ToDoName {
  public static let inputText = "투두명"
  public static let placeholderText = "투두명을 입력해주세요."
}

extension Constant.TextInputView.StringLiteral.UserIntroduction {
  public static let inputText = "소개"
  public static let placeholderText = "당신을 소개해주세요."
}
