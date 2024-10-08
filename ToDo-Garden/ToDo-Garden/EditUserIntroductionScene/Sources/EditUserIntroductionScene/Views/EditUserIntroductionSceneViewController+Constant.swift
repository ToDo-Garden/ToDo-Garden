//
//  EditUserIntroductionSceneViewController+Constant.swift
//
//
//  Created by Wood on 10/8/24.
//

import Foundation

extension EditUserIntroductionSceneViewController {
  enum Constant {}
}

extension EditUserIntroductionSceneViewController.Constant {
  enum Layout {}
  enum StringLiteral {}
}

extension EditUserIntroductionSceneViewController.Constant.Layout {
  enum DoneButton {
    static let horizontalOffset: CGFloat = 10
  }

  enum InputUserIntroductionView {
    static let topMarginRatio: CGFloat = 23 / 812
    static let widthRatio: CGFloat = 275 / 375
  }
}

extension EditUserIntroductionSceneViewController.Constant.StringLiteral {
  enum DoneButton {
    static let title = "완료"
  }

  static let title = "소개 변경"
}
