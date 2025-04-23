//
//  SettingViewController+Constant.swift
//
//
//  Created by Wood on 8/8/24.
//

import UIKit

extension SettingViewController {
  enum Constant {}
}

extension SettingViewController.Constant {
  enum SettingLabel {}
  enum ProfileRow {}
  enum UserGuideButton {}
  enum SettingCollectionView {}
  enum VersionInfoView {}
}

extension SettingViewController.Constant.UserGuideButton {
  enum Layer {
    static let cornerRadius: CGFloat = 10
    static let borderWidth: CGFloat = 1.0
  }

  static let spacing: CGFloat = 3
  static let layoutMargins = UIEdgeInsets(top: 7, left: 11, bottom: 7, right: 8)

  static let topMargin: CGFloat = 21
  static let height: CGFloat = 40
}

extension SettingViewController.Constant.SettingLabel {
  static let topMargin: CGFloat = 21
  static let leadingMargin: CGFloat = 28
}

extension SettingViewController.Constant.VersionInfoView {
  enum VersionInfoLabel {
    static let topMargin: CGFloat = 7
    static let leadingMargin: CGFloat = 4
  }

  enum UpdateButton {
    static let cornerRadius: CGFloat = 10
    static let topMargin: CGFloat = 7
    static let leadingMargin: CGFloat = 21
    static let height: CGFloat = 40
  }

  static let topMargin: CGFloat = 22
  static let leadingMargin: CGFloat = 4
  static let height: CGFloat = 81
}

extension SettingViewController.Constant.ProfileRow {
  enum Layer {
    static let cornerRadius: CGFloat = 10
    static let borderWidth: CGFloat = 1.0
  }

  static let topMargin: CGFloat = 15
  static let trailingMargin: CGFloat = 28
}

extension SettingViewController.Constant.SettingCollectionView {
  static let topMargin: CGFloat = 22
  static let height: CGFloat = 200
}
