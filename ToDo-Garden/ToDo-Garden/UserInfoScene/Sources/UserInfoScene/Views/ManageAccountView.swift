//
//  ManageAccountView.swift
//
//
//  Created by Wood on 9/3/24.
//

import UIKit

final class ManageAccountView: UIView {
  private let logOutButton: UIButton
  private let withdrawMembershipButton: UIButton

  weak var delegate: ManageAccountViewDelegate?

  init() {
    self.logOutButton = UIButton()
    self.withdrawMembershipButton = UIButton()
    super.init(frame: CGRect.zero)
    self.setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: ManageAccountView Delegate

protocol ManageAccountViewDelegate: AnyObject {
  func didSelectLogOutButton()
  func didSelectWithdrawMembershipButton()
}

// MARK: Private Functions

extension ManageAccountView {
  private func setup() {
    self.setupLogOutButtonTitle()
    self.setupLogOutButtonAction()
    self.setupWithdrawMembershipButton()
    self.setupWithdrawMembershipButtonAction()
    self.setupSubviewsLayout()
  }

  private func setupLogOutButtonTitle() {
    self.logOutButton.backgroundColor = UIColor.toDoGardenGreenBackground
    let cornerRadius = UserInfoSceneViewController.Constant.LogOutButton.Layer.cornerRadius
    self.logOutButton.layer.cornerRadius = cornerRadius
    self.logOutButton.setTitleColor(UIColor.toDoGardenEditButtonRed, for: UIControl.State.normal)
    let title = NSAttributedString(
      string: UserInfoSceneTheme.StringLiteral.LogOutButton.title,
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardBodyMedium,
        NSAttributedString.Key.strokeColor: UIColor.toDoGardenEditButtonRed
      ]
    )
    self.logOutButton.setAttributedTitle(title, for: UIControl.State.normal)
  }

  private func setupLogOutButtonAction() {
    let buttonAction = UIAction { _ in
      print("called")
      self.delegate?.didSelectLogOutButton()
    }

    self.logOutButton.addAction(buttonAction, for: UIControl.Event.touchUpInside)
  }

  private func setupWithdrawMembershipButton() {
    let buttonTitle = UserInfoSceneTheme.StringLiteral.WithdrawMembershipButton.title
    let attributedTitle = buttonTitle.applyTextAttributes(
      attributes: [
        NSAttributedString.Key.font: UIFont.pretendardBodySemiBold15,
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGray2,
        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
        NSAttributedString.Key.underlineColor: UIColor.toDoGardenGray2
      ]
    )

    self.withdrawMembershipButton.setAttributedTitle(attributedTitle, for: UIControl.State.normal)
  }

  private func setupWithdrawMembershipButtonAction() {
    let buttonAction = UIAction { _ in
      print("called")
      self.delegate?.didSelectWithdrawMembershipButton()
    }

    self.withdrawMembershipButton.addAction(buttonAction, for: UIControl.Event.touchUpInside)
  }
}

// MARK: Auto Layout

extension ManageAccountView {
  private func setupSubviewsLayout() {
    self.setupLogOutButtonLayout()
    self.setupLogOutButtonTitleLayout()
    self.setupWithdrawMembershipButtonLayout()
  }

  private func setupLogOutButtonLayout() {
    self.addSubview(self.logOutButton)
    self.logOutButton.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.logOutButton.topAnchor.constraint(equalTo: self.topAnchor),
        self.logOutButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        self.logOutButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        self.logOutButton.heightAnchor.constraint(
          equalToConstant: UserInfoSceneViewController.Constant.LogOutButton.height
        )
      ]
    )
  }

  private func setupLogOutButtonTitleLayout() {
    if let titleLabel = self.logOutButton.titleLabel {
      titleLabel.usingAutolayout()

      NSLayoutConstraint.activate(
        [
          titleLabel.leadingAnchor.constraint(
            equalTo: self.logOutButton.leadingAnchor,
            constant: UserInfoSceneViewController.Constant.LogOutButton.titleLeadingMargin
          ),
          titleLabel.centerYAnchor.constraint(equalTo: self.logOutButton.centerYAnchor)
        ]
      )
    }
  }

  private func setupWithdrawMembershipButtonLayout() {
    self.addSubview(self.withdrawMembershipButton)
    self.withdrawMembershipButton.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.withdrawMembershipButton.topAnchor.constraint(
          equalTo: self.logOutButton.bottomAnchor,
          constant: UserInfoSceneViewController.Constant.WithdrawMembershipButton.topMargin
        ),
        self.withdrawMembershipButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
      ]
    )
  }
}
