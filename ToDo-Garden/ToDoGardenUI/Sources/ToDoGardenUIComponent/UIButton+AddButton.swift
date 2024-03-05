//
//  UIButton+addButton.swift
//
//
//  Created by Wood on 3/4/24.
//

import ToDoGardenUIResource
import UIKit.UIButton

extension UIButton {
  public func addButtonStyle(with title: String) {
    self.setupUIAppearance(with: title)
  }
}

extension UIButton {
  private func setupUIAppearance(with title: String) {
    AddButtonStyle.apply(for: self, with: title)
  }
}

private enum AddButtonStyle {
  fileprivate static func apply(for button: UIButton, with title: String) {
    
  }
}

extension AddButtonStyle {
  private static func setupImage(for button: UIButton) {
    let renderingMode = UIImage.RenderingMode.alwaysTemplate
    let imagePadding: CGFloat = 4.0
    var configuration = UIButton.Configuration.plain()
    configuration.image = UIImage.addButton.withRenderingMode(renderingMode)
    configuration.imagePadding = imagePadding
    configuration.imagePlacement = NSDirectionalRectEdge.leading
    button.configuration = configuration
  }

  /// 버튼의 상태에 따라 tintColor를 변경해 이미지 색상을 변화시키도록 설정하는 메서드입니다.
  private static func setupTintColorWhenStateChanged(for button: UIButton) {
    button.configurationUpdateHandler = { button in
      switch button.state {
      case UIControl.State.normal:
        button.tintColor = UIColor.toDoGardenGreenDark
      case UIControl.State.highlighted:
        let alphaWhenHighlighted: CGFloat = 0.5
        button.tintColor = UIColor.toDoGardenGreenDark.withAlphaComponent(alphaWhenHighlighted)
      default:
        return
      }
    }
  }
}
