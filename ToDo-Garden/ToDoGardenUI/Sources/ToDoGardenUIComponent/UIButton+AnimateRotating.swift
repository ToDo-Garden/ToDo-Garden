//
//  UIButton+AnimateRotating.swift
//
//
//  Created by Wood on 7/10/24.
//

import UIKit

extension UIButton {
  public func animateRotating(with duration: CGFloat) {
    self.changesSelectionAsPrimaryAction = true
    let transform = self.isSelected ? CGAffineTransform.identity : CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    UIView.animate(withDuration: duration) {
      self.transform = transform
    }
  }
}

@available(iOS 17.0, *)
#Preview {
  let button = UIButton()
  button.setImage(UIImage.forwardButtonImage, for: UIControl.State.normal)
  button.addAction(
    UIAction { [weak button] _ in
      button?.animateRotating(with: 0.2)
    },
    for: UIControl.Event.touchUpInside
  )
  return button
}
