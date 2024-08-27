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

  @ExecuteOnce private var isSetupLayerCalled: (() -> Void)?

  override init(frame: CGRect) {
    self.cellPosition = Position.middle
    self.titleLabel = UILabel()
    self.rightForwardImageView = UIImageView()
    super.init(frame: frame)
    self.setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    self.removeSubLayersInMiddle()
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

// MARK: Draw Borders

extension SettingCollectionViewCell {
  private func setupLayer() {
    self.isSetupLayerCalled = {
      switch self.cellPosition {
      case Position.top:
        self.setupRoundedCornerInFirstCell()
      case Position.middle:
        self.setupBordersInMiddleCell()
      case Position.bottom:
        self.layer.addBottomRoundedBorder(
          color: UIColor.toDoGardenGreenBackground,
          width: 1.0,
          cornerRadius: 10
        )
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

  private func setupBordersInMiddleCell() {
    let layers = [
      self.addLeadingBorderLayer(),
      self.addBottomBorderLayer(),
      self.addTrailingBorderLayer()
    ]

    layers.forEach { (layer: CALayer) in
      layer.borderWidth = 1.0
      layer.borderColor = UIColor.toDoGardenGreenBackground.cgColor
      self.layer.addSublayer(layer)
    }
  }

  private func addLeadingBorderLayer() -> CALayer {
    let leadingLayer = CALayer()
    leadingLayer.frame = CGRect(
      x: self.bounds.minX,
      y: self.bounds.minY,
      width: 1.0,
      height: self.bounds.height
    )
    leadingLayer.name = SubLayerName.trailing
    return leadingLayer
  }

  private func addBottomBorderLayer() -> CALayer {
    let bottomLayer = CALayer()
    bottomLayer.frame = CGRect(
      x: self.bounds.minX,
      y: self.bounds.maxY - 1.0,
      width: self.bounds.width,
      height: 1.0
    )
    bottomLayer.name = SubLayerName.trailing
    return bottomLayer
  }

  private func addTrailingBorderLayer() -> CALayer {
    let trailingLayer = CALayer()
    trailingLayer.frame = CGRect(
      x: self.bounds.maxX - 1.0,
      y: self.bounds.minY,
      width: 1.0,
      height: self.bounds.height
    )
    trailingLayer.name = SubLayerName.trailing
    return trailingLayer
  }

  private func removeSubLayersInMiddle() {
    self.layer.sublayers?.forEach { (subLayer: CALayer) in
      if subLayer.name == SubLayerName.leading ||
        subLayer.name == SubLayerName.bottom ||
        subLayer.name == SubLayerName.trailing ||
        subLayer.name == CALayer.SubLayerName.bottomRoundedBorder {
        subLayer.removeFromSuperlayer()
      }
    }
  }
}

// MARK: Private Functions

extension SettingCollectionViewCell {
  private func setup() {
    self.backgroundColor = UIColor.toDoGardenWhite
    self.setupRightForwardImageView()
    self.setupTitleLabel()
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
}

extension SettingCollectionViewCell {
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

extension SettingCollectionViewCell {
  enum SubLayerName: CaseIterable {
    static let leading = "leading"
    static let trailing = "leading"
    static let bottom = "bottom"
  }
}
