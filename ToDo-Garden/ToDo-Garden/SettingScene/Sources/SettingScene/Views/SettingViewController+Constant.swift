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
  enum AppSupportView {}
  enum UserGuideButton {}
  enum UserSettingView {}
  enum SettingButtonStackView {}
  enum SettingLabel {}
  enum VersionInfoView {}
}

extension SettingViewController.Constant.AppSupportView {
  enum LeftImageView {
    static let width: CGFloat = 18
    static let heightMultiplier: CGFloat = 1.0
  }

  enum SettingButtonStackView {
    static let topMargin: CGFloat = 4
  }
}

extension SettingViewController.Constant.UserGuideButton {
  enum Layer {
    static let cornerRadius: CGFloat = 10
    static let borderWidth: CGFloat = 1.0
  }

  static let spacing: CGFloat = 3
  static let layoutMargins = UIEdgeInsets(top: 7, left: 11, bottom: 7, right: 8)
}

extension SettingViewController.Constant.UserSettingView {
  enum LeftImageView {
    static let width: CGFloat = 18
    static let heightMultiplier: CGFloat = 1.0
  }

  enum SettingButtonStackView {
    static let topMargin: CGFloat = 4
  }
}

extension SettingViewController.Constant.SettingButtonStackView {
  enum Layer {
    static let cornerRadius: CGFloat = 10
    static let borderWidth: CGFloat = 1.0
  }

  enum ImageView {
    static let trailingMargin: CGFloat = 8
  }

  enum TitleLabel {
    static let leadingMargin: CGFloat = 12
  }

  static let spacing: CGFloat = 1.0
  static let buttonHeight: CGFloat = 40
}

extension SettingViewController.Constant.SettingLabel {
  static let topMargin: CGFloat = 21
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
}
