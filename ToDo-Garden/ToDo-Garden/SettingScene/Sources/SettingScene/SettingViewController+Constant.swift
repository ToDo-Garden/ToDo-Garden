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
  enum UserGuideButton {}
}

extension SettingViewController.Constant.UserGuideButton {
  enum Layer {
    static let cornerRadius: CGFloat = 10
    static let borderWidth: CGFloat = 1.0
  }

  static let spacing: CGFloat = 3
  static let layoutMargins = UIEdgeInsets(top: 7, left: 11, bottom: 7, right: 8)
}
