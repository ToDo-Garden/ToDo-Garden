//
//  ProfileInfoView.swift
//
//
//  Created by Wood on 9/3/24.
//

import UIKit

final class ProfileInfoView: UIView {
  private let profileImageView: UIImageView
  private let editProfileImageButton: UIButton

  weak var delegate: ProfileInfoViewDelegate?

  init() {
    self.profileImageView = UIImageView()
    self.editProfileImageButton = UIButton()
    super.init(frame: CGRect.zero)
    self.setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func updateImage(_ image: UIImage) {
    self.profileImageView.image = image
  }
}

protocol ProfileInfoViewDelegate: AnyObject {
  func didSelectEditProfileButton()
}

// MARK: Private Functions

extension ProfileInfoView {
  private func setup() {
    self.setupProfileImageView()
    self.setupEditProfileImageButton()
    self.setupEditProfileImageButtonAction()
    self.setupSubviewsLayout()
  }

  private func setupProfileImageView() {
    let height = UserInfoSceneViewController.Constant.ProfileImageView.size.height
    self.profileImageView.layer.cornerRadius = height / 2
    self.profileImageView.contentMode = UIView.ContentMode.scaleAspectFill
    self.profileImageView.clipsToBounds = true
    self.profileImageView.image = UIImage.defaultProfileImage
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

  private func setupEditProfileImageButtonAction() {
    let buttonAction = UIAction { _ in
      self.delegate?.didSelectEditProfileButton()
    }

    self.editProfileImageButton.addAction(buttonAction, for: UIControl.Event.touchUpInside)
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
