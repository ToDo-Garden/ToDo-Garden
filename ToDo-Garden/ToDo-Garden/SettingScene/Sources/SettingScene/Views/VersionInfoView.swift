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

  weak var delegate: VersionInfoViewDelegate?

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

@MainActor
protocol VersionInfoViewDelegate: AnyObject {
  func didSelectUpdateButton()
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
    self.setupUpdateButtonAction()
  }

  private func setupUpdateButtonTitle() {
    var configuration = UIButton.Configuration.plain()
    var title = AttributedString(SettingSceneTheme.StringLiteral.VersionInfoView.updateButtonTitle)
    title.font = UIFont.pretendardBodySemiBold
    title.foregroundColor = SettingSceneTheme.mainColor
    configuration.attributedTitle = title
    configuration.cornerStyle = UIButton.Configuration.CornerStyle.large
    self.updateButton.configuration = configuration
    self.updateButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.leading
  }

  private func setupUpdateButtonAction() {
    let action = UIAction { _ in
      self.delegate?.didSelectUpdateButton()
    }

    self.updateButton.addAction(action, for: UIControl.Event.touchUpInside)
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

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let stackView = UIStackView()
  stackView.axis = .vertical
  stackView.widthAnchor.constraint(equalToConstant: 300).isActive = true
  let emptyView = UIView()
  emptyView.heightAnchor.constraint(equalToConstant: 100).isActive = true
  stackView.addArrangedSubview(emptyView)
  let view = VersionInfoView()
  view.updateToPriorVersion("v.0.1.2")
  stackView.addArrangedSubview(view)
  return stackView
}
#endif
