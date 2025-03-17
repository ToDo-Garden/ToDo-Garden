//
//  UserGuideButton.swift
//
//
//  Created by Wood on 8/8/24.
//

import UIKit

import ToDoGardenUIResource

final class UserGuideButton: UIStackView {
  var touchAction: (() -> Void)?
  
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
    self.setupGestureRecognizer()
  }

  private func setupStackViewUI() {
    self.isLayoutMarginsRelativeArrangement = true
    let constant = SettingViewController.Constant.UserGuideButton.self
    self.layoutMargins = constant.layoutMargins
    self.spacing = constant.spacing
    self.backgroundColor = UIColor.toDoGardenGreenBackground
    self.layer.cornerRadius = constant.Layer.cornerRadius
    self.layer.borderWidth = constant.Layer.borderWidth
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
    userGuideLabel.text = SettingSceneTheme.StringLiteral.UserGuideButton.title
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
  
  private func setupGestureRecognizer() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
    self.addGestureRecognizer(tapGesture)
  }
}

extension UserGuideButton {
  @objc private func handleTap() {
    self.touchAction?()
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  return UserGuideButton()
}
#endif
