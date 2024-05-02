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
}

// MARK: Private Functions

extension CreateToDoButton {
  private func setupUI() {
    self.setupConfiguration()
    self.setupTitle()
    self.setupRightImage()
    self.setupBackgroundColor()
    self.setupContentsLayout()
  }

  private func setupConfiguration() {
    var configuration = UIButton.Configuration.filled()
    configuration.cornerStyle = UIButton.Configuration.CornerStyle.capsule
    self.configuration = configuration
  }

  private func setupTitle() {
    let attributes = AttributeContainer(
      [
        NSAttributedString.Key.font: UIFont.pretendardBodyBold,
        NSAttributedString.Key.foregroundColor: UIColor.toDoGardenGreenDark
      ]
    )
    let attributedTtile = AttributedString(
      self.primaryModel.title,
      attributes: attributes
    )
    self.configuration?.attributedTitle = attributedTtile
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
    var title: String
    var imagePadding: CGFloat
    var contentInsets: NSDirectionalEdgeInsets
    var image: UIImage

    public init(
      title: String,
      imagePadding: CGFloat = Constant.CreateToDoButton.Layout.Primary.imagePadding,
      contentInsets: NSDirectionalEdgeInsets = Constant.CreateToDoButton.Layout.Primary.contentInsets,
      image: UIImage = UIImage.createToDoButtonImage
    ) {
      self.title = title
      self.imagePadding = imagePadding
      self.contentInsets = contentInsets
      self.image = image
    }
  }
}
