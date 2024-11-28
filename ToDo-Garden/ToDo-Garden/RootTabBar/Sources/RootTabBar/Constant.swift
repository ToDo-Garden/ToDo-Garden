//
//  Constant.swift
//  RootTabBar
//
//  Created by Noah on 11/28/24.
//

import Foundation
import struct UIKit.UIEdgeInsets

enum Constant {
  enum Layout { }
  enum StringLiteral { }
}

extension Constant.Layout {
  enum RootTabBar { }
}

extension Constant.StringLiteral {
  enum RootTabBarController { }
}

extension Constant.Layout.RootTabBar {
  static let imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -3, right: 0)
}

extension Constant.StringLiteral.RootTabBarController {
  static let homeTabTitle = "홈"
  static let shareTabTitle = "공유"
  static let settingsTabTitle = "설정"
}
