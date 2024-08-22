//
//  SettingCollectionViewCell.swift
//
//
//  Created by Wood on 8/19/24.
//

import UIKit

import TDUtility
import ToDoGardenUIComponent

final class SettingCollectionViewCell: UICollectionViewCell, ReusableIdentifier {
  enum Position {
    case top
    case middle
    case bottom
  }

  private var cellPosition: Position
  private let titleLabel: UILabel
  private let rightForwardImageView: UIImageView
  private let leadingBorderView: UIView
  private let trailingBorderView: UIView
  private let bottomBorderView: UIView

  @ExecuteOnce private var isSetupLayerCalled: (() -> Void)?

  override init(frame: CGRect) {
    self.cellPosition = Position.middle
    self.leadingBorderView = UIView()
    self.trailingBorderView = UIView()
    self.bottomBorderView = UIView()
    self.titleLabel = UILabel()
    self.rightForwardImageView = UIImageView()
    super.init(frame: frame)
    self.setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func draw(_ rect: CGRect) {
    super.draw(rect)
    self.setupLayer()
  }

  func updateUI(title: String, isShowingModal: Bool, position: Position) {
    self.titleLabel.text = title
    self.rightForwardImageView.isHidden = !isShowingModal
    self.cellPosition = position
  }
}

extension SettingCollectionViewCell {
  private func setupLayer() {
    self.isSetupLayerCalled = {
      switch self.cellPosition {
      case Position.top:
        self.setupRoundedCornerInFirstCell()
        self.removeBorderViews()
      case Position.middle:
        self.setupBorderViewsColor()
      case Position.bottom:
        self.layer.addBottomRoundedBorder(
          color: UIColor.toDoGardenGreenBackground,
          width: 1.0,
          cornerRadius: 10
        )
        self.removeBorderViews()
      }
    }
  }

  private func setupRoundedCornerInFirstCell() {
    self.layer.maskedCorners = [
      CACornerMask.layerMinXMinYCorner,
      CACornerMask.layerMaxXMinYCorner
    ]
    self.layer.cornerRadius = 10
    self.layer.borderColor = UIColor.toDoGardenGreenBackground.cgColor
    self.layer.borderWidth = 1.0
  }

  private func setup() {
    self.backgroundColor = UIColor.toDoGardenWhite
    self.setupRightForwardImageView()
    self.setupTitleLabel()
    self.setupBorderViewsLayout()
  }

  private func setupRightForwardImageView() {
    self.rightForwardImageView.image = UIImage.forwardButtonImage
    self.setupRightForwardImageViewLayout()
  }

  private func setupTitleLabel() {
    self.titleLabel.font = UIFont.pretendardBodyRegular
    self.titleLabel.textColor = SettingSceneTheme.mainColor
    self.setupTitleLabelLayout()
  }

  private func setupBorderViewsColor() {
    self.leadingBorderView.backgroundColor = UIColor.toDoGardenGreenBackground
    self.trailingBorderView.backgroundColor = UIColor.toDoGardenGreenBackground
    self.bottomBorderView.backgroundColor = UIColor.toDoGardenGreenBackground
  }

  private func removeBorderViews() {
    self.leadingBorderView.removeFromSuperview()
    self.trailingBorderView.removeFromSuperview()
    self.bottomBorderView.removeFromSuperview()
  }
}

extension SettingCollectionViewCell {
  private func setupBorderViewsLayout() {
    self.setupLeadingBorderViewLayout()
    self.setupTrailingBorderViewLayout()
    self.setupBottomBorderViewLayout()
  }

  private func setupLeadingBorderViewLayout() {
    self.contentView.addSubview(self.leadingBorderView)
    self.leadingBorderView.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.leadingBorderView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
        self.leadingBorderView.widthAnchor.constraint(equalToConstant: 1.0),
        self.leadingBorderView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
        self.leadingBorderView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
      ]
    )
  }

  private func setupTrailingBorderViewLayout() {
    self.contentView.addSubview(self.trailingBorderView)
    self.trailingBorderView.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.trailingBorderView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        self.trailingBorderView.widthAnchor.constraint(equalToConstant: 1.0),
        self.trailingBorderView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
        self.trailingBorderView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
      ]
    )
  }

  private func setupBottomBorderViewLayout() {
    self.contentView.addSubview(self.bottomBorderView)
    self.bottomBorderView.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.bottomBorderView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        self.bottomBorderView.leadingAnchor.constraint(equalTo: self.leadingBorderView.trailingAnchor),
        self.bottomBorderView.trailingAnchor.constraint(equalTo: self.trailingBorderView.leadingAnchor),
        self.bottomBorderView.heightAnchor.constraint(equalToConstant: 1.0)
      ]
    )
  }

  private func setupRightForwardImageViewLayout() {
    self.contentView.addSubview(self.rightForwardImageView)
    self.rightForwardImageView.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.rightForwardImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
        self.rightForwardImageView.trailingAnchor.constraint(
          equalTo: self.contentView.trailingAnchor,
          constant: -8
        ),
        self.rightForwardImageView.widthAnchor.constraint(equalToConstant: 24),
        self.rightForwardImageView.heightAnchor.constraint(equalToConstant: 24)
      ]
    )
  }

  private func setupTitleLabelLayout() {
    self.contentView.addSubview(self.titleLabel)
    self.titleLabel.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
        self.titleLabel.leadingAnchor.constraint(
          equalTo: self.contentView.leadingAnchor,
          constant: 8
        ),
        self.titleLabel.trailingAnchor.constraint(equalTo: self.rightForwardImageView.leadingAnchor)
      ]
    )
  }
}
