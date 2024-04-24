//
//  UIButton+ToDoGardenPlainButton.swift
//
//
//  Created by Wood on 4/18/24.
//

import UIKit

extension UIButton { 
  public func toDoGardenPlainButtonStyle(with image: UIImage) {
    ToDoGardenPlainButtonStyle.apply(to: self, with: image)
  }
}

private enum ToDoGardenPlainButtonStyle {
  static func apply(to button: UIButton, with image: UIImage) {
    self.setupNormalStateImage(to: button, with: image)
  }
}

extension ToDoGardenPlainButtonStyle {
  private static func setupNormalStateImage(to button: UIButton, with image: UIImage) {
    button.setImage(image, for: UIControl.State.normal)
  }
}
