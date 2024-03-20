//
//  ToDoGardenBoxButton.swift
//
//
//  Created by SONG on 3/20/24.
//

import UIKit.UIButton

import ToDoGardenUIConstant

public class ToDoGardenBoxButton: UIButton {
  public override var isEnabled: Bool {
    didSet{
      self.updateBackgroundColor()
    }
  }
  
  private var isRoundRect: Bool = true
  
  init() {
    super.init(frame: CGRect.zero)
    self.enable()
  }
  
  public convenience init(
    isRoundRect: Bool,
    text: String,
    sizeType: ToDoGardenBoxButtonConstant.Size
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
    self.enable()
  }
  
  public func enable() {
    self.isEnabled = true
  }
  
  public func disable() {
    self.isEnabled = false
  }
}

//private method

extension ToDoGardenBoxButton {
  private func setup(
    _ isRoundRect: Bool,
    _ text: String,
    _ sizeType: ToDoGardenBoxButtonConstant.Size
  ) {
    self.isRoundRect = isRoundRect
    self.setTitle(text, for: UIControl.State.normal)
    self.setupFont()
    self.setCornerRadius(value: sizeType.cornerRadius)
    self.setupActionToChangeAlpha()
  }
  
  private func setupFont() {
    self.titleLabel?.font = UIFont.pretendardHeadBold
  }
  
  private func setupActionToChangeAlpha() {
    let touchDownAction = UIAction { [weak self] _ in
      self?.alpha = ToDoGardenBoxButtonConstant.Alpha.highlighted.value
    }
    
    let touchUpAction = UIAction { [weak self] _ in
      self?.alpha = ToDoGardenBoxButtonConstant.Alpha.normal.value
    }
    
    self.addAction(touchDownAction, for: UIControl.Event.touchDown)
    
    self.addAction(touchUpAction, for: [
      UIControl.Event.touchUpInside,
      UIControl.Event.touchUpOutside,
      UIControl.Event.touchCancel
    ])
  }
  
  private func setCornerRadius(value: CGFloat) {
    if self.isRoundRect {
      self.layer.cornerRadius = value
    }
  }
  
  private func updateBackgroundColor() {
    if self.isEnabled {
      self.backgroundColor = UIColor.toDoGardenGreenDark
    }
    else {
      self.backgroundColor = UIColor.toDoGardenGreenGray
    }
  }
}
