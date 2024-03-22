//
//  ToDoGardenBoxButton.swift
//
//
//  Created by SONG on 3/22/24.
//

import UIKit.UIButton

public final class ToDoGardenBoxButton: UIButton {
  public override var isEnabled: Bool {
    didSet {
      self.updateBackgroundColor()
    }
  }
  
  private var isRoundRect: Bool?
  
  init() {
    super.init(frame: CGRect.zero)
    enable()
  }
  
  public convenience init(
    isRoundRect: Bool,
    text: String,
    sizeType: CGSize
  ) {
    self.init()
    self.setup(
      isRoundRect,
      text,
      sizeType
    )
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    enable()
  }
  
  public func enable() {
    self.isEnabled = true
  }
  
  public func disable() {
    self.isEnabled = false
  }
}

// private method

extension ToDoGardenBoxButton {
  private func setup(
    _ isRoundRect: Bool,
    _ text: String,
    _ size: CGSize
  ) {
    self.isRoundRect = isRoundRect
    self.setTitle(text, for: UIControl.State.normal)
    self.setupFont()
    self.setupCornerRadius(with: size.height / 2)
  }
  
  private func setupFont() {
    self.titleLabel?.font = UIFont.pretendardHeadBold
  }
  
  private func setupCornerRadius(with value: CGFloat) {
    guard let isRoundRect = self.isRoundRect else { return }
    
    if isRoundRect {
      self.layer.cornerRadius = value
    }
  }
  
  private func updateBackgroundColor() {
    if self.isEnabled {
      self.backgroundColor = UIColor.toDoGardenGreenDark
    } else {
      self.backgroundColor = UIColor.toDoGardenGreenGray
    }
  }
}
