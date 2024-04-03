//
//  ToDoGardenBoxButton.swift
//
//
//  Created by SONG on 3/22/24.
//

import UIKit.UIButton

import ToDoGardenUIConstant

public final class ToDoGardenBoxButton: UIButton {
  public override var isEnabled: Bool {
    didSet {
      self.updateBackgroundColor()
    }
  }
  
  init() {
    super.init(frame: CGRect.zero)
  }
  
  public convenience init(
    isRoundRect: Bool,
    text: String,
    size: CGSize,
    isEnabled: Bool
  ) {
    self.init()
    self.isEnabled = isEnabled
    self.setup(
      isRoundRect: isRoundRect,
      text: text,
      size: size
    )
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  public func enable() {
    self.isEnabled = true
  }
  
  public func disable() {
    self.isEnabled = false
  }
}

// MARK: - private functions

extension ToDoGardenBoxButton {
  private func setup(
    isRoundRect: Bool,
    text: String,
    size: CGSize
  ) {
    if isRoundRect {
      self.setupCornerRadius(with: size.height / 2)
    }
    self.updateBackgroundColor()
    self.setTitle(text, for: UIControl.State.normal)
    self.setupTitleFont()
    self.setupActionToChangeAlpha()
  }
  
  private func setupTitleFont() {
    self.titleLabel?.font = UIFont.pretendardHeadBold
  }
  
  private func setupCornerRadius(with value: CGFloat) {
    self.layer.cornerRadius = value
  }
  
  private func setupActionToChangeAlpha() {
    self.setupTouchDownAction()
    self.setupTouchUpAction()
  }
  
  private func setupTouchDownAction() {
    let touchDownAction = UIAction { [weak self] _ in
      self?.alpha = Constant.ToDoGardenBoxButton.Alpha.highlighted
    }
    
    self.addAction(touchDownAction, for: UIControl.Event.touchDown)
  }
  
  private func setupTouchUpAction() {
    let touchUpAction = UIAction { [weak self] _ in
      self?.alpha = Constant.ToDoGardenBoxButton.Alpha.normal
    }
    
    self.addAction(
      touchUpAction,
      for: [
        UIControl.Event.touchUpInside,
        UIControl.Event.touchUpOutside,
        UIControl.Event.touchCancel
      ]
    )
  }
  
  private func updateBackgroundColor() {
    if self.isEnabled {
      self.backgroundColor = UIColor.toDoGardenGreenDark
    } else {
      self.backgroundColor = UIColor.toDoGardenGreenGray
    }
  }
}
