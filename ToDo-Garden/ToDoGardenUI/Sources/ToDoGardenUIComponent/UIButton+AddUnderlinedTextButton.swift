//
//  UIButton+AddUnderlinedTextButton.swift
//
//
//  Created by Wood on 3/4/24.
//

import UIKit.UIButton

import ToDoGardenUIConstant
import ToDoGardenUIResource

extension UIButton {
  public func applyAddUnderlinedTextButtonStyle(with title: String) {
    AddUnderlinedTextButtonStyle.apply(for: self, with: title)
  }
}

private enum AddUnderlinedTextButtonStyle {
  fileprivate static func apply(
    for button: UIButton,
    with title: String
  ) {
    AddUnderlinedTextButtonStyle.applyConfiguration(
      for: button,
      with: UIButton.Configuration.plain()
    )
    AddUnderlinedTextButtonStyle.configureImage(for: button)
    AddUnderlinedTextButtonStyle.setupImage(for: button)
    AddUnderlinedTextButtonStyle.setupTintColorWhenStateChanged(for: button)
    AddUnderlinedTextButtonStyle.setupTitle(for: button, with: title)
  }
}

extension AddUnderlinedTextButtonStyle {
  private static func applyConfiguration(
    for button: UIButton,
    with configuration: UIButton.Configuration
  ) {
    button.configuration = configuration
  }

  private static func configureImage(for button: UIButton) {
    button.configuration?.imagePadding = Constant.AddUnderlinedTextButton.Layout.imagePadding
    button.configuration?.imagePlacement = NSDirectionalRectEdge.leading
  }

  private static func setupImage(for button: UIButton) {
    let renderingMode = UIImage.RenderingMode.alwaysTemplate
    let addButtonImage = UIImage.addButton.withRenderingMode(renderingMode)
    button.setImage(addButtonImage, for: UIControl.State.normal)
  }

  /// 버튼의 상태에 따라 tintColor를 변경해 이미지 색상을 변화시키도록 설정하는 메서드입니다.
  private static func setupTintColorWhenStateChanged(for button: UIButton) {
    button.configurationUpdateHandler = { button in
      switch button.state {
      case UIControl.State.normal:
        button.tintColor = UIColor.toDoGardenGreenDark
      case UIControl.State.highlighted:
        button.tintColor = UIColor.toDoGardenGreenDark.withAlphaComponent(
          Constant.AddUnderlinedTextButton.Alpha.highlighted
        )
      default:
        return
      }
    }
  }

  private static func setupTitle(for button: UIButton, with title: String) {
    AddUnderlinedTextButtonStyle.setupTitleForNormalState(for: button, with: title)
    AddUnderlinedTextButtonStyle.setupTitleForHighlightedState(for: button, with: title)
  }

  private static func setupTitleForNormalState(
    for button: UIButton,
    with title: String
  ) {
    let attributedTitle = AddUnderlinedTextButtonStyle.makeAttributedTitle(
      from: title,
      with: UIColor.toDoGardenGreenDark
    )
    AddUnderlinedTextButtonStyle.addUnderline(
      to: attributedTitle,
      with: UIColor.toDoGardenGreenDark
    )

    button.setAttributedTitle(attributedTitle, for: UIControl.State.normal)
  }

  private static func setupTitleForHighlightedState(
    for button: UIButton,
    with title: String
  ) {
    let attributedTitle = AddUnderlinedTextButtonStyle.makeAttributedTitle(
      from: title,
      with: UIColor.toDoGardenGreenDark.withAlphaComponent(
        Constant.AddUnderlinedTextButton.Alpha.highlighted
      )
    )
    AddUnderlinedTextButtonStyle.addUnderline(
      to: attributedTitle,
      with: UIColor.toDoGardenGreenDark.withAlphaComponent(
        Constant.AddUnderlinedTextButton.Alpha.highlighted
      )
    )

    button.setAttributedTitle(attributedTitle, for: UIControl.State.highlighted)
  }

  private static func makeAttributedTitle(
    from title: String,
    with titleColor: UIColor
  ) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString(
      string: title,
      attributes: [
        NSAttributedString.Key.baselineOffset: Constant.AddUnderlinedTextButton.Title.baselineOffset,
        NSAttributedString.Key.font: UIFont.pretendardBodySemiBold,
        NSAttributedString.Key.foregroundColor: titleColor
      ]
    )

    return attributedString
  }

  private static func addUnderline(
    to title: NSMutableAttributedString,
    with unedrlineColor: UIColor
  ) {
    let endPoint = title.length
    title.addUnderline(
      with: unedrlineColor,
      from: Constant.AddUnderlinedTextButton.Title.startPoint,
      to: endPoint
    )
  }
}
