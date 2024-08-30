//
//  SettingCollectionViewCell.swift
//
//
//  Created by Wood on 8/30/24.
//

import UIKit

import TDUtility

public final class SettingCollectionViewCell: UICollectionViewCell, ReusableIdentifier {
  public enum Position {
    case top
    case middle
    case bottom
  }

  private var cellPosition: Position
  private let titleLabel: UILabel
  private let rightForwardImageView: UIImageView

  @ExecuteOnce private var isSetupLayerCalled: (() -> Void)?

  public override init(frame: CGRect) {
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

  public override func prepareForReuse() {
    super.prepareForReuse()
    self.removeSubLayersInMiddle()
  }

  public override func draw(_ rect: CGRect) {
    super.draw(rect)
    self.isSetupLayerCalled = {
      self.addBorderLayer(for: self.cellPosition)
    }
  }

  public func updateUI(title: String, isShowingModal: Bool, position: Position) {
    self.titleLabel.text = title
    self.rightForwardImageView.isHidden = !isShowingModal
    self.cellPosition = position
  }
}

// MARK: Draw Borders

extension SettingCollectionViewCell {
  private func removeSubLayersInMiddle() {
    self.layer.sublayers?.forEach { (subLayer: CALayer) in
      if subLayer.name == SubLayerName.leading ||
        subLayer.name == SubLayerName.bottom ||
        subLayer.name == SubLayerName.trailing ||
        subLayer.name == SubLayerName.roundedBottom {
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
    self.titleLabel.textColor = UIColor.toDoGardenGreenDark
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
  enum SubLayerName {
    static let leading = "leading"
    static let trailing = "trailing"
    static let bottom = "bottom"
    static let roundedBottom = "roundedBottom"
  }
}
