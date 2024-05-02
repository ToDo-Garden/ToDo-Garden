//
//  CreateToDoButton.swift
//
//
//  Created by Wood on 5/2/24.
//

import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

public final class CreateToDoButton: UIButton {
  private var primaryModel: CreateToDoButton.PrimaryModel

  public init(primaryModel: CreateToDoButton.PrimaryModel) {
    self.primaryModel = primaryModel
    super.init(frame: CGRect.zero)
    self.setupUI()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func updateTitle(with groupName: String) {
    self.configuration?.attributedTitle = self.makeAttributedTitle(with: groupName)
  }
}

// MARK: Private Functions

extension CreateToDoButton {
  private func makeAttributedTitle(with groupName: String) -> AttributedString {
    let attributes = AttributeContainer(
      [
        NSAttributedString.Key.font: UIFont.pretendardBodyBold,
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
      ]
    )
    return AttributedString(
      groupName,
      attributes: attributes
    )
  }

  private func setupUI() {
    self.setupConfiguration()
    self.setupRightImage()
    self.setupBackgroundColor()
    self.setupContentsLayout()
  }

  private func setupConfiguration() {
    var configuration = UIButton.Configuration.filled()
    configuration.cornerStyle = UIButton.Configuration.CornerStyle.capsule
    self.configuration = configuration
  }

  private func setupBackgroundColor() {
    self.configuration?.baseBackgroundColor = UIColor.toDoGardenGreenBackground
  }

  private func setupRightImage() {
    self.configuration?.image = self.primaryModel.image
  }

  private func setupContentsLayout() {
    self.configuration?.contentInsets = self.primaryModel.contentInsets
    self.configuration?.imagePadding = self.primaryModel.imagePadding
    self.configuration?.imagePlacement = NSDirectionalRectEdge.trailing
  }
}

// MARK: Primary Model

extension CreateToDoButton {
  public struct PrimaryModel {
    let imagePadding: CGFloat
    let contentInsets: NSDirectionalEdgeInsets
    let image: UIImage
    let font: UIFont
    let textColor: UIColor

    public init(
      imagePadding: CGFloat = Constant.CreateToDoButton.Layout.Primary.imagePadding,
      contentInsets: NSDirectionalEdgeInsets = Constant.CreateToDoButton.Layout.Primary.contentInsets,
      image: UIImage = UIImage.createToDoButtonImage,
      font: UIFont = UIFont.pretendardBodyBold,
      textColor: UIColor = UIColor.toDoGardenGreenDark
    ) {
      self.imagePadding = imagePadding
      self.contentInsets = contentInsets
      self.image = image
      self.font = font
      self.textColor = textColor
    }
  }
}
