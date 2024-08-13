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
    self.setupProfileRowLayout(settingLabel)
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
        ),
        label.leadingAnchor.constraint(equalTo: self.profileRow.leadingAnchor),
        label.trailingAnchor.constraint(equalTo: self.profileRow.trailingAnchor)
      ]
    )
  }

  private func setupProfileRowLayout(_ label: UILabel) {
    self.profileRow.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.profileRow.topAnchor.constraint(
          equalTo: label.bottomAnchor,
          constant: Constant.ProfileRow.topMargin
        ),
        self.profileRow.leadingAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,
          constant: Constant.ProfileRow.leadingMargin
        ),
        self.profileRow.trailingAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
          constant: -Constant.ProfileRow.trailingMargin
        )
      ]
    )
  }
}
