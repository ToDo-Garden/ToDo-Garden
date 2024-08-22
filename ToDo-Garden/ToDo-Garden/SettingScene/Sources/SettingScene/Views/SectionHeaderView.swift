//
//  SectionHeaderView.swift
//
//
//  Created by Wood on 8/21/24.
//

import UIKit

import ToDoGardenUIComponent
import ToDoGardenUIResource

final class SectionHeaderView: UICollectionReusableView, ReusableIdentifier {
  private let iconImageView: UIImageView
  private let titleLabel: UILabel

  override init(frame: CGRect) {
    self.iconImageView = UIImageView()
    self.titleLabel = UILabel()
    super.init(frame: CGRect.zero)
    self.setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func updateUI(image: UIImage, title: String) {
    self.iconImageView.image = image
    self.titleLabel.text = title
  }
}

extension SectionHeaderView {
  private func setup() {
    self.setupTitleLabel()
    self.setupSubviewsLayout()
  }

  private func setupTitleLabel() {
    self.titleLabel.font = UIFont.pretendardBodySemiBold15
    self.titleLabel.textColor = SettingSceneTheme.mainColor
  }
}

extension SectionHeaderView {
  private func setupSubviewsLayout() {
    self.setupIconImageViewLayout()
    self.setupTitleLabelLayout()
  }

  private func setupIconImageViewLayout() {
    self.addSubview(self.iconImageView)
    self.iconImageView.usingAutolayout()

    NSLayoutConstraint.activate([
      self.iconImageView.topAnchor.constraint(
        equalTo: self.topAnchor
      ),
      self.iconImageView.leadingAnchor.constraint(
        equalTo: self.leadingAnchor,
        constant: 4
      ),
      self.iconImageView.widthAnchor.constraint(equalToConstant: 18),
      self.iconImageView.heightAnchor.constraint(equalToConstant: 18)
    ])
  }

  private func setupTitleLabelLayout() {
    self.addSubview(self.titleLabel)
    self.titleLabel.usingAutolayout()

    NSLayoutConstraint.activate([
      self.titleLabel.leadingAnchor.constraint(
        equalTo: self.iconImageView.trailingAnchor,
        constant: 1
      ),
      self.titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor),
      self.titleLabel.centerYAnchor.constraint(equalTo: self.iconImageView.centerYAnchor)
    ])
  }
}
