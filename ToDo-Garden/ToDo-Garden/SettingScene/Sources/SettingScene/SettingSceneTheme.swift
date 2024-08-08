//
//  SettingSceneTheme.swift
//
//
//  Created by Wood on 8/8/24.
//

import UIKit.UIColor

import TDUtility

enum SettingSceneTheme {
  @DynamicUIProperty static var mainColor = UIColor.toDoGardenGreenDark
}

extension SettingSceneTheme {
  enum StringLiteral {}
}

extension SettingSceneTheme.StringLiteral {
  enum UserGuideButton {}
  enum UserSettingView {}
}

extension SettingSceneTheme.StringLiteral.UserGuideButton {
  static let title = "이용 가이드"
}

extension SettingSceneTheme.StringLiteral.UserSettingView {
  static let userSettingLabelText = "사용자 설정"
  static let alarmSettingButtonTitle = "알림 설정"
  static let remindSettingButtonTitle = "리마인드 설정"
}
