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
  enum ProfileRow {}
  enum SettingLabel {}
  enum UserGuideButton {}
  enum VersionInfoView {}
}

extension SettingSceneTheme.StringLiteral.ProfileRow {
  static let description = "프로필 및 계정 관리"
}

extension SettingSceneTheme.StringLiteral.SettingLabel {
  static let text = "설정"
}

extension SettingSceneTheme.StringLiteral.UserGuideButton {
  static let title = "이용 가이드"
}
extension SettingSceneTheme.StringLiteral.VersionInfoView {
  static let versionInfoLabelText = "버전정보"
  static let updateButtonTitle = "최신버전으로 업데이트"
  static let latestVersionText = "최신 버전"
  static let priorVersionText = "업데이트 필요"
}
