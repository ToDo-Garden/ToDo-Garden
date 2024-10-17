//
//  SettingCollectionViewCell.swift
//
//
//  Created by Wood on 8/30/24.
//

import UIKit

import TDUtility

open class SettingCollectionViewCell: UICollectionViewCell, ReusableIdentifier {
  public enum Position {
    case top
    case middle
    case bottom
  }

  private var cellPosition: Position
  private let titleLabel: UILabel
  private let descriptionLabel: UILabel
  private let rightButton: UIButton

  @ExecuteOnce private var isSetupLayerCalled: (() -> Void)?

  public override init(frame: CGRect) {
    self.cellPosition = Position.middle
    self.titleLabel = UILabel()
    self.descriptionLabel = UILabel()
    self.rightButton = UIButton()
    super.init(frame: frame)
    self.setup()
  }

  @available(*, unavailable)
  required public init?(coder: NSCoder) {
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

  public func setupUI(
    title: String,
    titleFont: UIFont,
    isShowingModal: Bool,
    position: Position
  ) {
    self.titleLabel.text = title
    self.titleLabel.font = titleFont
    self.rightButton.isHidden = !isShowingModal
    self.cellPosition = position
  }

  public func setupRightButtonAction(_ action: UIAction) {
    self.rightButton.addAction(action, for: UIControl.Event.touchUpInside)
  }

  public func updateDescription(_ text: String?) {
    self.descriptionLabel.text = text
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
    self.setupDescriptionLabel()
  }

  private func setupRightForwardImageView() {
    self.rightButton.setImage(UIImage.forwardButtonImage, for: UIControl.State.normal)
    self.setupRightForwardImageViewLayout()
  }

  private func setupTitleLabel() {
    self.titleLabel.font = UIFont.pretendardBodyRegular
    self.titleLabel.textColor = UIColor.toDoGardenGreenDark
    self.setupTitleLabelLayout()
  }

  private func setupDescriptionLabel() {
    self.descriptionLabel.textColor = UIColor.toDoGardenGray3
    self.descriptionLabel.font = UIFont.pretendardBodyMedium
    self.setupDescriptionLabelLayout()
  }
}

extension SettingCollectionViewCell {
  private func setupRightForwardImageViewLayout() {
    self.contentView.addSubview(self.rightButton)
    self.rightButton.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.rightButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
        self.rightButton.trailingAnchor.constraint(
          equalTo: self.contentView.trailingAnchor,
          constant: -8
        ),
        self.rightButton.widthAnchor.constraint(equalToConstant: 24),
        self.rightButton.heightAnchor.constraint(equalToConstant: 24)
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
        )
      ]
    )
  }

  private func setupDescriptionLabelLayout() {
    self.contentView.addSubview(self.descriptionLabel)
    self.descriptionLabel.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.descriptionLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.titleLabel.trailingAnchor),
        self.descriptionLabel.trailingAnchor.constraint(
          equalTo: self.rightButton.leadingAnchor,
          constant: -3
        ),
        self.descriptionLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
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

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let stackView = UIStackView()
  stackView.axis = .vertical
  stackView.spacing = 20
  stackView.distribution = .equalSpacing

  let settingSceneCell = SettingCollectionViewCell()
  settingSceneCell.widthAnchor.constraint(equalToConstant: 300).isActive = true
  settingSceneCell.heightAnchor.constraint(equalToConstant: 40).isActive = true
  settingSceneCell.setupUI(
    title: "공지사항",
    titleFont: UIFont.pretendardBodyRegular,
    isShowingModal: true,
    position: SettingCollectionViewCell.Position.top
  )
  stackView.addArrangedSubview(settingSceneCell)

  let userInfoSceneCell = SettingCollectionViewCell()
  userInfoSceneCell.heightAnchor.constraint(equalToConstant: 40).isActive = true
  userInfoSceneCell.setupUI(
    title: "이메일",
    titleFont: UIFont.pretendardBodyMedium,
    isShowingModal: false,
    position: SettingCollectionViewCell.Position.bottom
  )
  userInfoSceneCell.updateDescription("wood0203@gmail.com")
  stackView.addArrangedSubview(userInfoSceneCell)

  return stackView
}
#endif
