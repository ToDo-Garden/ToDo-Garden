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
  
  private var isRoundRect: Bool?
  
  init() {
    super.init(frame: CGRect.zero)
  }
  
  public convenience init(
    isRoundRect: Bool,
    text: String,
    sizeType: CGSize
    isEnabled: Bool
  ) {
    self.init()
    self.isEnabled = isEnabled
    self.setup(
      isRoundRect,
      text,
      sizeType
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
    self.setupActionToChangeAlpha()
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
