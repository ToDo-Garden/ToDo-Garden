//
//  Constant+CheckBoxAlertView.swift
//  ToDoGardenUI
//
//  Created by SONG on 3/11/25.
//

import Foundation

extension Constant.CheckBoxAlertView {
  public enum Layout { }
  public enum StringLiteral { }
}

extension Constant.CheckBoxAlertView.Layout {
  public static let backgroundAlpha: CGFloat = 0.5
  public static let containerCornerRadius: CGFloat = 16
  public static let containerWidth: CGFloat = 300
  public static let containerMinHeight: CGFloat = 120
  public static let verticalSpacing: CGFloat = 12
  public static let horizontalSpacing: CGFloat = 8
  public static let verticalStackTopPadding: CGFloat = 20
  public static let horizontalPadding: CGFloat = 16
  public static let buttonTopPadding: CGFloat = 40
  public static let buttonBottomPadding: CGFloat = 16
  public static let buttonHeight: CGFloat = 30
  public static let checkBoxHeight: CGFloat = 40
  public static let checkBoxWidth: CGFloat = 120
  public static let checkBoxLeadingPadding: CGFloat = 87.5
}

extension Constant.CheckBoxAlertView.StringLiteral {
  public static let mainMessage: String = "타이머 완료시 알림을 받기 위해서는\n권한 허용이 필요합니다."
  public static let checkBoxMessage: String = "다시 묻지 않음"
  public static let settingButtonTitle: String = "설정으로 이동"
  public static let cancelButtonTitle: String = "취소"
}
