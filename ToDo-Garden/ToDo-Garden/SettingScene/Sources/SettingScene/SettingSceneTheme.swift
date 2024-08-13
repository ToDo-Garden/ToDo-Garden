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
  enum AppSupportView {}
  enum SettingLabel {}
  enum UserGuideButton {}
  enum UserSettingView {}
  enum VersionInfoView {}
}

extension SettingSceneTheme.StringLiteral.AppSupportView {
  static let appSupportLabelText = "앱 정보 및 지원"
  static let announcementButtonTitle = "공지사항"
  static let privacyPolicyButtonTitle = "개인정보 처리 방침"
  static let termsOfUseButtonTitle = "서비스 이용 약관"
  static let sendFeedbackButtonTitle = "피드백 보내기"
}

extension SettingSceneTheme.StringLiteral.SettingLabel {
  static let text = "설정"
}

extension SettingSceneTheme.StringLiteral.UserGuideButton {
  static let title = "이용 가이드"
}

extension SettingSceneTheme.StringLiteral.UserSettingView {
  static let userSettingLabelText = "사용자 설정"
  static let alarmSettingButtonTitle = "알림 설정"
  static let remindSettingButtonTitle = "리마인드 설정"
}

extension SettingSceneTheme.StringLiteral.VersionInfoView {
  static let versionInfoLabelText = "버전정보"
  static let updateButtonTitle = "최신버전으로 업데이트"
  static let latestVersionText = "최신 버전"
  static let priorVersionText = "업데이트 필요"
}
