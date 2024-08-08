//
//  UserGuideButton.swift
//
//
//  Created by Wood on 8/8/24.
//

import UIKit

import ToDoGardenUIResource

final class UserGuideButton: UIStackView {
  init() {
    super.init(frame: CGRect.zero)
    self.setupUI()
  }

  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Private Functions
extension UserGuideButton {
  private func setupUI() {
    self.setupStackViewUI()
    self.setupEditIconImageView()
    self.setupToDoGardenLogoImageView()
    self.setupUserGuideLabel()
    self.setupRightForwardImage()
  }

  private func setupStackViewUI() {
    self.isLayoutMarginsRelativeArrangement = true
    self.layoutMargins = UIEdgeInsets(top: 7, left: 15, bottom: 7, right: 8)
    self.spacing = 5
    self.backgroundColor = UIColor.toDoGardenGreenBackground
    self.layer.cornerRadius = 10
    self.layer.borderWidth = 1.0
    self.layer.borderColor = UIColor.toDoGardenGreenGray.cgColor
  }

  private func setupEditIconImageView() {
    let editIconImageView = UIImageView()
    editIconImageView.image = UIImage.editIconImage.withTintColor(UIColor.toDoGardenGreenDark)
    editIconImageView.setContentHuggingPriority(
      UILayoutPriority.defaultHigh,
      for: NSLayoutConstraint.Axis.horizontal
    )
    self.addArrangedSubview(editIconImageView)
  }

  private func setupToDoGardenLogoImageView() {
    let userGuideImageView = UIImageView()
    userGuideImageView.image = UIImage.toDoGardenLogoImage
    userGuideImageView.setContentHuggingPriority(
      UILayoutPriority.defaultHigh,
      for: NSLayoutConstraint.Axis.horizontal
    )
    self.addArrangedSubview(userGuideImageView)
  }

  private func setupUserGuideLabel() {
    let userGuideLabel = UILabel()
    userGuideLabel.font = UIFont.pretendardDetailLight
    userGuideLabel.textColor = UIColor.toDoGardenGreenDark
    userGuideLabel.text = "이용 가이드"
    userGuideLabel.textAlignment = NSTextAlignment.left
    userGuideLabel.setContentHuggingPriority(
      UILayoutPriority.defaultLow,
      for: NSLayoutConstraint.Axis.horizontal
    )
    self.addArrangedSubview(userGuideLabel)
  }

  private func setupRightForwardImage() {
    let rightForwardImageView = UIImageView()
    rightForwardImageView.image = UIImage.forwardButtonImage
    rightForwardImageView.setContentHuggingPriority(
      UILayoutPriority.defaultHigh,
      for: NSLayoutConstraint.Axis.horizontal
    )
    self.addArrangedSubview(rightForwardImageView)
  }
}
