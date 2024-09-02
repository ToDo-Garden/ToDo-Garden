//
//  UserInfoSceneViewController+SectionHeaderView.swift
//
//
//  Created by Wood on 9/2/24.
//

import UIKit

import ToDoGardenUIComponent

extension UserInfoSceneViewController {
  final class SectionHeaderView: UICollectionReusableView, ReusableIdentifier {
    private let titleLabel: UILabel

    override init(frame: CGRect) {
      self.titleLabel = UILabel()
      super.init(frame: frame)
      self.setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    func updateUI(title: String) {
      self.titleLabel.text = title
    }
  }
}

extension UserInfoSceneViewController.SectionHeaderView {
  private func setup() {
    self.setupTitleLabel()
    self.setupTitleLabelLayout()
  }

  private func setupTitleLabel() {
    self.titleLabel.font = UIFont.pretendardBodySemiBold15
    self.titleLabel.textColor = UserInfoSceneTheme.mainColor
  }
}

extension UserInfoSceneViewController.SectionHeaderView {
  private func setupTitleLabelLayout() {
    self.addSubview(self.titleLabel)
    self.titleLabel.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
        self.titleLabel.leadingAnchor.constraint(
          equalTo: self.leadingAnchor,
          constant: UserInfoSceneViewController.Constant.SectionHeaderView.leadingMargin
        )
      ]
    )
  }
}
