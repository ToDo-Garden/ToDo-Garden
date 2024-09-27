//
//  EditUserNameSceneViewController+Constant.swift
//
//
//  Created by Wood on 9/27/24.
//

import Foundation

extension EditUserNameSceneViewController {
  enum Constant {}
}

extension EditUserNameSceneViewController.Constant {
  enum Layout {}
  enum StringLiteral {}
}

extension EditUserNameSceneViewController.Constant.Layout {
  enum EditUserNameButton {
    static let titleHorizontalOffset: CGFloat = 10
  }

  enum InputUserNameView {
    static let topMargin: CGFloat = 50 / 812
    static let widthRatio: CGFloat = 275 / 375
  }
}

extension EditUserNameSceneViewController.Constant.StringLiteral {
  enum EditUserNameButton {
    static let title = "완료"
  }

  static let title = "닉네임 변경"
}
