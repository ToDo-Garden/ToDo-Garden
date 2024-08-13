//
//  UserSettingView.swift
//
//
//  Created by Wood on 8/8/24.
//

import UIKit

final class UserSettingView: UIView {
  private let settingButtonStackView: SettingButtonStackView

  weak var delegate: UserSettingViewDelegate?

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

// MARK: Delegate Functions

protocol UserSettingViewDelegate: AnyObject {
  func didSelectSettingAlarmButton()
  func didSelectSettingRemindButton()
}

// MARK: Private Functions

extension UserSettingView {
  private func setup() {
    self.setupAlarmSettingButtonAction()
    self.setupRemindSettingButtonAction()
    self.setupLeftImageView()
  }

  private func setupAlarmSettingButtonAction() {
    let action = UIAction { _ in
      self.delegate?.didSelectSettingAlarmButton()
    }

    let alarmSettingButton = UIButton(primaryAction: action)
    self.settingButtonStackView.addSettingButton(
      alarmSettingButton,
      title: SettingSceneTheme.StringLiteral.UserSettingView.alarmSettingButtonTitle,
      isForwardImageNeeded: true
    )
  }

  private func setupRemindSettingButtonAction() {
    let action = UIAction { _ in
      self.delegate?.didSelectSettingRemindButton()
    }

    let remindSettingButton = UIButton(primaryAction: action)
    self.settingButtonStackView.addSettingButton(
      remindSettingButton,
      title: SettingSceneTheme.StringLiteral.UserSettingView.remindSettingButtonTitle,
      isForwardImageNeeded: true
    )
  }

  private func setupLeftImageView() {
    let leftImageView = UIImageView()
    leftImageView.image = UIImage.bellIconImage
    leftImageView.translatesAutoresizingMaskIntoConstraints = false
    self.setupLeftImageViewLayout(leftImageView)
    self.setupUserSettingLabel(with: leftImageView)
    self.setupSettingButtonStackViewLayout(leftImageView)
  }

  private func setupUserSettingLabel(with leftImageView: UIImageView) {
    let userSettingLabel = UILabel()
    userSettingLabel.font = UIFont.pretendardBodySemiBold15
    userSettingLabel.text = SettingSceneTheme.StringLiteral.UserSettingView.userSettingLabelText
    userSettingLabel.textColor = SettingSceneTheme.mainColor
    self.setupUserSettingLabelLayout(userSettingLabel, leftImageView)
  }
}

// MARK: Auto Layout

extension UserSettingView {
  private func setupLeftImageViewLayout(_ imageView: UIImageView) {
    self.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false

    let layout = SettingViewController.Constant.UserSettingView.LeftImageView.self
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

    let layout = SettingViewController.Constant.UserSettingView.SettingButtonStackView.self
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

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let view = UserSettingView()
  view.widthAnchor.constraint(equalToConstant: 300).isActive = true
  return view
}
#endif
