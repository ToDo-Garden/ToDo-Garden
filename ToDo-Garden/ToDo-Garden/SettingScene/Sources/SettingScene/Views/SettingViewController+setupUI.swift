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
    self.setupProfileRowUI()
    self.setupUserGuideButton()
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

  private func setupProfileRowUI() {
    self.profileRow.layer.cornerRadius = Constant.ProfileRow.Layer.cornerRadius
    self.profileRow.layer.borderWidth = Constant.ProfileRow.Layer.borderWidth
    self.profileRow.layer.borderColor = UIColor.toDoGardenGreenBackground.cgColor
  }

  private func setupUserGuideButton() {
    let userGuideButton = UserGuideButton()
    self.setupUserGuideButtonLayout(userGuideButton)
    self.setupUserSettingView(with: userGuideButton)
  }

  private func setupUserSettingView(with userGuideButton: UIView) {
    let userSettingView = UserSettingView()
    self.setupUserSettingViewLayout(userSettingView, with: userGuideButton)
    self.setupAppSupportView(with: userSettingView)
  }

  private func setupAppSupportView(with userSettingView: UIView) {
    let appSupportView = AppSupportView()
    self.setupAppSupportViewLayout(appSupportView, with: userSettingView)
    self.setupVersionInfoViewLayout(with: appSupportView)
  }
}

// MARK: Auto Layout

extension SettingViewController {
  private func setupSettingLabelLayout(_ label: UILabel) {
    self.view.addSubview(label)
    label.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        label.topAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.topAnchor,
          constant: Constant.SettingLabel.topMargin
        ),
        label.leadingAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,
          constant: Constant.SettingLabel.leadingMargin
        )
      ]
    )
  }

  private func setupProfileRowLayout(_ label: UILabel) {
    self.view.addSubview(self.profileRow)
    self.profileRow.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.profileRow.topAnchor.constraint(
          equalTo: label.bottomAnchor,
          constant: Constant.ProfileRow.topMargin
        ),
        self.profileRow.leadingAnchor.constraint(equalTo: label.leadingAnchor),
        self.profileRow.trailingAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
          constant: -Constant.ProfileRow.trailingMargin
        )
      ]
    )
  }

  private func setupUserGuideButtonLayout(_ userGuideButton: UIView) {
    self.view.addSubview(userGuideButton)
    userGuideButton.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        userGuideButton.topAnchor.constraint(
          equalTo: self.profileRow.bottomAnchor,
          constant: Constant.UserGuideButton.topMargin
        ),
        userGuideButton.leadingAnchor.constraint(equalTo: self.profileRow.leadingAnchor),
        userGuideButton.trailingAnchor.constraint(equalTo: self.profileRow.trailingAnchor),
        userGuideButton.heightAnchor.constraint(equalToConstant: Constant.UserGuideButton.height)
      ]
    )
  }

  private func setupUserSettingViewLayout(_ userSettingView: UIView, with userGuideButton: UIView) {
    self.view.addSubview(userSettingView)
    userSettingView.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        userSettingView.topAnchor.constraint(
          equalTo: userGuideButton.bottomAnchor,
          constant: Constant.UserSettingView.topMargin
        ),
        userSettingView.leadingAnchor.constraint(equalTo: self.profileRow.leadingAnchor),
        userSettingView.trailingAnchor.constraint(equalTo: self.profileRow.trailingAnchor),
        userSettingView.heightAnchor.constraint(equalToConstant: Constant.UserSettingView.height)
      ]
    )
  }

  private func setupAppSupportViewLayout(_ appSupportView: UIView, with userSettingView: UIView) {
    self.view.addSubview(appSupportView)
    appSupportView.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        appSupportView.topAnchor.constraint(
          equalTo: userSettingView.bottomAnchor,
          constant: Constant.AppSupportView.topMargin
        ),
        appSupportView.leadingAnchor.constraint(equalTo: self.profileRow.leadingAnchor),
        appSupportView.trailingAnchor.constraint(equalTo: self.profileRow.trailingAnchor),
        appSupportView.heightAnchor.constraint(equalToConstant: Constant.AppSupportView.height)
      ]
    )
  }

  private func setupVersionInfoViewLayout(with appSupportView: UIView) {
    self.view.addSubview(self.versionInfoView)
    self.versionInfoView.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.versionInfoView.topAnchor.constraint(
          equalTo: appSupportView.bottomAnchor,
          constant: Constant.VersionInfoView.topMargin
        ),
        self.versionInfoView.leadingAnchor.constraint(
          equalTo: appSupportView.leadingAnchor,
          constant: -Constant.VersionInfoView.leadingMargin
        ),
        self.versionInfoView.trailingAnchor.constraint(equalTo: appSupportView.trailingAnchor),
        self.versionInfoView.heightAnchor.constraint(equalToConstant: Constant.VersionInfoView.height)
      ]
    )
  }
}
