//
//  UIButton+SearchGardenButton.swift
//
//
//  Created by Wood on 4/19/24.
//

import UIKit.UIButton

import ToDoGardenUIConstant
import ToDoGardenUIResource

extension UIButton {
  public func searchGardenButtonStyle() {
    SearchGardenButtonStyle.apply(to: self)
  }
}

private enum SearchGardenButtonStyle {
  fileprivate static func apply(to button: UIButton) {
    self.setupBackgroundColor(to: button)
    self.setupRoundedCorner(to: button)
    self.setupNormalStateImage(to: button)
    self.setupButtonImageViewContentMode(to: button)
    self.setupButtonImageViewLayout(to: button)
  }
}

extension SearchGardenButtonStyle {
  private static func setupBackgroundColor(to button: UIButton) {
    button.backgroundColor = UIColor.toDoGardenGreenBackground
  }

  private static func setupRoundedCorner(to button: UIButton) {
    button.layer.cornerRadius = Constant.SearchGardenButton.Layout.cornerRadius
  }

  private static func setupNormalStateImage(to button: UIButton) {
    button.setImage(UIImage.searchIconImage, for: UIControl.State.normal)
  }

  private static func setupButtonImageViewContentMode(to button: UIButton) {
    button.imageView?.contentMode = UIView.ContentMode.right
  }

  private static func setupButtonImageViewLayout(to button: UIButton) {
    button.imageView?.usingAutolayout()

    button.imageView?.trailingAnchor.constraint(
      equalTo: button.trailingAnchor,
      constant: -Constant.SearchGardenButton.Layout.ImageView.trailingMargin
    ).isActive = true
  }
}
