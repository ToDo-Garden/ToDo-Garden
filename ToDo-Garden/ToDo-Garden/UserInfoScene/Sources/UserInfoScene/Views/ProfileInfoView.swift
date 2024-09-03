//
//  ProfileInfoView.swift
//
//
//  Created by Wood on 9/3/24.
//

import UIKit

import ToDoGardenUIComponent

final class ProfileInfoView: UIView {
  private let profileImageView: ProfileImageView
  private let editProfileImageButton: UIButton

  init() {
    self.profileImageView = ProfileImageView(
      size: UserInfoSceneViewController.Constant.ProfileImageView.size
    )
    self.editProfileImageButton = UIButton()
    super.init(frame: CGRect.zero)
    self.setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Private Functions

extension ProfileInfoView {
  private func setup() {
    self.setupEditProfileImageButton()
    self.setupSubviewsLayout()
  }

  private func setupEditProfileImageButton() {
    let buttonTitle = UserInfoSceneTheme.StringLiteral.EditProfileImageButton.title
    let attributedTitle = buttonTitle.applyTextAttributes(
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardBodyMedium,
        NSAttributedString.Key.foregroundColor: UserInfoSceneTheme.mainColor,
        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
        NSAttributedString.Key.underlineColor: UserInfoSceneTheme.mainColor
      ]
    )

    self.editProfileImageButton.setAttributedTitle(attributedTitle, for: UIControl.State.normal)
  }
}

// MARK: Auto Layout

extension ProfileInfoView {
  private func setupSubviewsLayout() {
    self.setupProfileImageViewLayout()
    self.setupEditProfileImageButtonLayout()
  }

  private func setupProfileImageViewLayout() {
    self.addSubview(self.profileImageView)
    self.profileImageView.usingAutolayout()

    let constant = UserInfoSceneViewController.Constant.ProfileImageView.size
    NSLayoutConstraint.activate(
      [
        self.profileImageView.topAnchor.constraint(equalTo: self.topAnchor),
        self.profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        self.profileImageView.widthAnchor.constraint(equalToConstant: constant.width),
        self.profileImageView.heightAnchor.constraint(equalToConstant: constant.height)
      ]
    )
  }

  private func setupEditProfileImageButtonLayout() {
    self.addSubview(self.editProfileImageButton)
    self.editProfileImageButton.usingAutolayout()

    let constant = UserInfoSceneViewController.Constant.EditProfileImageButton.self
    NSLayoutConstraint.activate(
      [
        self.editProfileImageButton.topAnchor.constraint(
          equalTo: self.profileImageView.bottomAnchor,
          constant: constant.topMargin
        ),
        self.editProfileImageButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
      ]
    )
  }
}
