//
//  VersionInfoView.swift
//
//
//  Created by Wood on 8/8/24.
//

import UIKit

final class VersionInfoView: UIView {
  private let upToDateVersionLabel: UILabel
  private let currentVersionLabel: UILabel
  private let updateButton: UIButton

  init() {
    self.upToDateVersionLabel = UILabel()
    self.currentVersionLabel = UILabel()
    self.updateButton = UIButton()
    super.init(frame: CGRect.zero)
    self.setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func updateToLatestVersion(_ version: String) {
    self.upToDateVersionLabel.text = SettingSceneTheme.StringLiteral.VersionInfoView.latestVersionText
    self.currentVersionLabel.text = version
    self.updateButton.isHidden = true
  }

  func updateToPriorVersion(_ version: String) {
    self.upToDateVersionLabel.text = SettingSceneTheme.StringLiteral.VersionInfoView.priorVersionText
    self.currentVersionLabel.text = version
    self.updateButton.isHidden = false
  }
}

// MARK: Private Functions

extension VersionInfoView {
  private func setup() {
    self.setupVersionInfoLabel()
    self.setupUpToDateLabel()
    self.setupCurrentVersionLabel()
    self.setupUpdateButton()
    self.setupUpToDateVersionLabelLayout()
    self.setupCurrentVersionLabelLayout()
    self.setupUpdateButtonLayout()
  }

  private func setupVersionInfoLabel() {
    let label = UILabel()
    let text = NSMutableAttributedString(string: "")
    let attachment = NSTextAttachment(image: UIImage.leafImage)
    text.append(NSAttributedString(attachment: attachment))
    let title = NSAttributedString(
      string: SettingSceneTheme.StringLiteral.VersionInfoView.versionInfoLabelText,
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardBodySemiBold15,
        NSAttributedString.Key.foregroundColor: SettingSceneTheme.mainColor
      ]
    )
    text.append(title)
    label.attributedText = text
    self.setupVersionInfoLabelLayout(label)
  }

  private func setupUpToDateLabel() {
    self.upToDateVersionLabel.font = UIFont.pretendardBodySemiBold15
    self.upToDateVersionLabel.textColor = SettingSceneTheme.mainColor
  }

  private func setupCurrentVersionLabel() {
    self.currentVersionLabel.font = UIFont.pretendardBodySemiBold15
    self.currentVersionLabel.textColor = UIColor.toDoGardenGreenGray
  }

  private func setupUpdateButton() {
    self.updateButton.backgroundColor = UIColor.toDoGardenGreenBackground
    let layout = SettingViewController.Constant.VersionInfoView.UpdateButton.self
    self.updateButton.layer.cornerRadius = layout.cornerRadius
    self.setupUpdateButtonTitle()
  }

  private func setupUpdateButtonTitle() {
    let title = NSAttributedString(
      string: SettingSceneTheme.StringLiteral.VersionInfoView.updateButtonTitle,
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardBodyMedium,
        NSAttributedString.Key.foregroundColor: SettingSceneTheme.mainColor
      ]
    )
    self.updateButton.setAttributedTitle(title, for: UIControl.State.normal)
    self.updateButton.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
    self.updateButton.titleLabel?.centerYAnchor.constraint(
      equalTo: self.updateButton.centerYAnchor
    ).isActive = true
    self.updateButton.titleLabel?.leadingAnchor.constraint(
      equalTo: self.updateButton.leadingAnchor,
      constant: SettingViewController.Constant.VersionInfoView.UpdateButton.leadingMargin
    ).isActive = true
  }
}

// MARK: Auto Layout

extension VersionInfoView {
  private func setupVersionInfoLabelLayout(_ label: UILabel) {
    self.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false

    let layout = SettingViewController.Constant.VersionInfoView.VersionInfoLabel.self
    NSLayoutConstraint.activate(
      [
        label.topAnchor.constraint(
          equalTo: self.topAnchor,
          constant: layout.topMargin
        ),
        label.leadingAnchor.constraint(
          equalTo: self.leadingAnchor,
          constant: layout.leadingMargin
        )
      ]
    )
  }

  private func setupUpToDateVersionLabelLayout() {
    self.addSubview(self.upToDateVersionLabel)
    self.upToDateVersionLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        self.upToDateVersionLabel.topAnchor.constraint(equalTo: self.topAnchor),
        self.upToDateVersionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
      ]
    )
  }

  private func setupCurrentVersionLabelLayout() {
    self.addSubview(self.currentVersionLabel)
    self.currentVersionLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        self.currentVersionLabel.topAnchor.constraint(equalTo: self.upToDateVersionLabel.bottomAnchor),
        self.currentVersionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
      ]
    )
  }

  private func setupUpdateButtonLayout() {
    self.addSubview(self.updateButton)
    self.updateButton.translatesAutoresizingMaskIntoConstraints = false

    let layout = SettingViewController.Constant.VersionInfoView.UpdateButton.self
    NSLayoutConstraint.activate(
      [
        self.updateButton.topAnchor.constraint(
          equalTo: self.currentVersionLabel.bottomAnchor,
          constant: layout.topMargin
        ),
        self.updateButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        self.updateButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        self.updateButton.heightAnchor.constraint(
          equalToConstant: layout.height
        )
      ]
    )
  }
}
