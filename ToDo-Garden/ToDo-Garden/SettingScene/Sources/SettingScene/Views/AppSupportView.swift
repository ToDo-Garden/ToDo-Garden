//
//  AppSupportView.swift
//
//
//  Created by Wood on 8/8/24.
//

import UIKit

final class AppSupportView: UIView {
  private let settingButtonStackView: SettingButtonStackView

  weak var delegate: AppSupportViewDelegate?

  init() {
    self.settingButtonStackView = SettingButtonStackView()
    super.init(frame: CGRect.zero)
    self.setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Private Functions

protocol AppSupportViewDelegate: AnyObject {
  func didSelectAnnouncementButton()
  func didSelectPrivacyPolicyButton()
  func didSelectTemrsOfUseButton()
  func didSelectSendFeedBackButton()
}

// MARK: Private Functions

extension AppSupportView {
  private func setup() {
    self.setupAnnouncementButton()
    self.setupPrivacyPolicyButton()
    self.setupTermsOfUseButton()
    self.setupSendFeedbackButton()
    self.setupLeftImageView()
  }

  private func setupAnnouncementButton() {
    let action = UIAction { _ in
      self.delegate?.didSelectAnnouncementButton()
    }
    let announcementButton = UIButton(primaryAction: action)

    self.settingButtonStackView.addSettingButton(
      announcementButton,
      title: SettingSceneTheme.StringLiteral.AppSupportView.announcementButtonTitle,
      isForwardImageNeeded: true
    )
  }

  private func setupPrivacyPolicyButton() {
    let action = UIAction { _ in
      self.delegate?.didSelectPrivacyPolicyButton()
    }

    let privacyPolicyButton = UIButton(primaryAction: action)
    self.settingButtonStackView.addSettingButton(
      privacyPolicyButton,
      title: SettingSceneTheme.StringLiteral.AppSupportView.privacyPolicyButtonTitle,
      isForwardImageNeeded: false
    )
  }

  private func setupTermsOfUseButton() {
    let action = UIAction { _ in
      self.delegate?.didSelectTemrsOfUseButton()
    }

    let termsOfUseButton = UIButton(primaryAction: action)
    self.settingButtonStackView.addSettingButton(
      termsOfUseButton,
      title: SettingSceneTheme.StringLiteral.AppSupportView.termsOfUseButtonTitle,
      isForwardImageNeeded: false
    )
  }

  private func setupSendFeedbackButton() {
    let action = UIAction { _ in
      self.delegate?.didSelectTemrsOfUseButton()
    }

    let sendFeedBackButton = UIButton(primaryAction: action)
    self.settingButtonStackView.addSettingButton(
      sendFeedBackButton,
      title: SettingSceneTheme.StringLiteral.AppSupportView.sendFeedbackButtonTitle,
      isForwardImageNeeded: false
    )
  }

  private func setupLeftImageView() {
    let leftImageView = UIImageView()
    leftImageView.image = UIImage.leafImage
    leftImageView.translatesAutoresizingMaskIntoConstraints = false
    self.setupLeftImageViewLayout(leftImageView)
    self.setupUserSettingLabel(with: leftImageView)
    self.setupSettingButtonStackViewLayout(leftImageView)
  }

  private func setupUserSettingLabel(with leftImageView: UIImageView) {
    let userSettingLabel = UILabel()
    userSettingLabel.font = UIFont.pretendardBodySemiBold15
    userSettingLabel.text = SettingSceneTheme.StringLiteral.AppSupportView.appSupportLabelText
    userSettingLabel.textColor = SettingSceneTheme.mainColor
    self.setupUserSettingLabelLayout(userSettingLabel, leftImageView)
  }
}

// MARK: Auto Layout

extension AppSupportView {
  private func setupLeftImageViewLayout(_ imageView: UIImageView) {
    self.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false

    let layout = SettingViewController.Constant.AppSupportView.LeftImageView.self
    NSLayoutConstraint.activate(
      [
        imageView.topAnchor.constraint(equalTo: self.topAnchor),
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        imageView.widthAnchor.constraint(equalToConstant: layout.width),
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: layout.heightMultiplier)
      ]
    )
  }

  private func setupUserSettingLabelLayout(_ label: UILabel, _ leftImageView: UIImageView) {
    self.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        label.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor),
        label.centerYAnchor.constraint(equalTo: leftImageView.centerYAnchor)
      ]
    )
  }

  private func setupSettingButtonStackViewLayout(_ leftImageView: UIImageView) {
    self.addSubview(self.settingButtonStackView)
    self.settingButtonStackView.translatesAutoresizingMaskIntoConstraints = false

    let layout = SettingViewController.Constant.AppSupportView.SettingButtonStackView.self
    NSLayoutConstraint.activate(
      [
        self.settingButtonStackView.topAnchor.constraint(
          equalTo: leftImageView.bottomAnchor,
          constant: layout.topMargin
        ),
        self.settingButtonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        self.settingButtonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        self.settingButtonStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
      ]
    )
  }
}
