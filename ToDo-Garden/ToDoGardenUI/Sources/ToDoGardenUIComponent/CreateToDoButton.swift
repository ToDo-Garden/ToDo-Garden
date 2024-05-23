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
  private var model: CreateToDoButton.Model

  public init(model: CreateToDoButton.Model) {
    self.model = model
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
    self.configuration?.image = self.model.image
  }

  private func setupContentsLayout() {
    self.configuration?.contentInsets = self.model.contentInsets
    self.configuration?.imagePadding = self.model.imagePadding
    self.configuration?.imagePlacement = NSDirectionalRectEdge.trailing
  }
}

// MARK: Primary Model

extension CreateToDoButton {
  public struct Model {
    let imagePadding: CGFloat
    let contentInsets: NSDirectionalEdgeInsets
    let image: UIImage
    let font: UIFont
    let textColor: UIColor
  }
}

extension CreateToDoButton.Model {
  public static let primary = CreateToDoButton.Model(
    imagePadding: Constant.CreateToDoButton.Layout.Primary.imagePadding,
    contentInsets: NSDirectionalEdgeInsets(
      top: Constant.CreateToDoButton.Layout.Primary.topMargin,
      leading: Constant.CreateToDoButton.Layout.Primary.leadingMargin,
      bottom: Constant.CreateToDoButton.Layout.Primary.bottomMargin,
      trailing: Constant.CreateToDoButton.Layout.Primary.trailingMargin
    ),
    image: UIImage.createToDoButtonImage,
    font: UIFont.pretendardBodyBold,
    textColor: UIColor.toDoGardenGreenDark
  )
}
