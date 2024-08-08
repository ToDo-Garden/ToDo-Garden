//
//  SettingButtonStackView.swift
//
//
//  Created by Wood on 8/8/24.
//

import UIKit

/// 설정 화면에서 필요한 여러개의 버튼들을 담는 StackView 입니다. 
/// UserSettingView, AppSupportView에서 사용됩니다.
final class SettingButtonStackView: UIStackView {
  init() {
    super.init(frame: CGRect.zero)
    self.setup()
  }

  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func addSettingButton(_ button: UIButton, title: String, isForwardImageNeeded: Bool) {
    if isForwardImageNeeded {
      self.setupButtonImage(button)
    }

    self.setupButtonTitle(button, title: title)
    button.backgroundColor = UIColor.toDoGardenWhite
    button.heightAnchor.constraint(
      equalToConstant: SettingViewController.Constant.SettingButtonStackView.buttonHeight
    ).isActive = true
    self.addArrangedSubview(button)
  }
}

extension SettingButtonStackView {
  private func setup() {
    self.setupStackView()
    self.setupLayerUI()
  }

  private func setupStackView() {
    self.backgroundColor = UIColor.toDoGardenGreenBackground
    self.axis = NSLayoutConstraint.Axis.vertical
    self.distribution = UIStackView.Distribution.equalSpacing
    let layout = SettingViewController.Constant.SettingButtonStackView.self
    self.spacing = layout.spacing
  }

  private func setupLayerUI() {
    let layout = SettingViewController.Constant.SettingButtonStackView.self
    self.layer.cornerRadius = layout.Layer.cornerRadius
    self.layer.borderWidth = layout.Layer.borderWidth
    self.layer.borderColor = UIColor.toDoGardenGreenBackground.cgColor
  }

  private func setupButtonImage(_ button: UIButton) {
    button.setImage(UIImage.forwardButtonImage, for: UIControl.State.normal)
    button.imageView?.contentMode = .right
    button.imageView?.translatesAutoresizingMaskIntoConstraints = false
    button.imageView?.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
    button.imageView?.trailingAnchor.constraint(
      equalTo: button.trailingAnchor,
      constant: -SettingViewController.Constant.SettingButtonStackView.ImageView.trailingMargin
    ).isActive = true
  }

  private func setupButtonTitle(_ button: UIButton, title: String) {
    button.setAttributedTitle(
      NSAttributedString(
        string: title,
        attributes: [
          NSAttributedString.Key.font: UIFont.pretendardBodyRegular,
          NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
        ]
      ),
      for: UIControl.State.normal
    )

    button.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
    button.titleLabel?.leadingAnchor.constraint(
      equalTo: button.leadingAnchor,
      constant: SettingViewController.Constant.SettingButtonStackView.TitleLabel.leadingMargin
    ).isActive = true
    button.titleLabel?.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
  }
}
