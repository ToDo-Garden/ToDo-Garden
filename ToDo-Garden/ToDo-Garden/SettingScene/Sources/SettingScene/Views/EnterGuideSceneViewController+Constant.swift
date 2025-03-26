//
//  EnterGuideSceneViewController+Constant.swift
//  SettingScene
//
//  Created by SONG on 3/25/25.
//

import Foundation

extension EnterGuideSceneViewController {
  enum Constant {
    enum StringLiteral { }
    enum Layout { }
  }
}

extension EnterGuideSceneViewController.Constant.StringLiteral {
  static let mainTitle: String = "이용 가이드"
  static let homeTitle: String = "홈화면 가이드"
  static let groupManagementTitle: String = "그룹 관리하기"
  static let editToDoTitle: String = "투두 편집하기"
  static let shareGarden: String = "공유 탭 가이드"
}

extension EnterGuideSceneViewController.Constant.Layout {
  static let commonSpacing: CGFloat = 20.0
  static let top: CGFloat = 30.0
  static let height: CGFloat = 220.0
}
