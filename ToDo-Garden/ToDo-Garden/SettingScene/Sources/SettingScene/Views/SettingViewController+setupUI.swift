//
//  SettingViewController+setupUI.swift
//
//
//  Created by Wood on 8/13/24.
//

import UIKit

import ToDoGardenUIComponent

extension SettingViewController {
  func setupUI() {
    self.setupSettingLabel()
  }
}

extension SettingViewController {
  private func setupSettingLabel() {
    let settingLabel = UILabel()
    settingLabel.text = SettingSceneTheme.StringLiteral.SettingLabel.text
    settingLabel.font = UIFont.pretendardHeadBold
    settingLabel.textColor = SettingSceneTheme.mainColor
    self.setupSettingLabelLayout(settingLabel)
  }
}

// MARK: Auto Layout

extension SettingViewController {
  private func setupSettingLabelLayout(_ label: UILabel) {
    label.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        label.topAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.topAnchor,
          constant: Constant.SettingLabel.topMargin
        )
      ]
    )
  }
}
