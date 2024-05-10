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
  private let size: CGSize
  
  public init(title: String, configuration: Configuration) {
    self.size = configuration.dataStore.size
    super.init(frame: CGRect.zero)
    self.setup(title: title, configuration: configuration)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override public var intrinsicContentSize: CGSize {
    return self.size
  }
  
  public func enable() {
    self.isEnabled = true
  }
  
  public func disable() {
    self.isEnabled = false
  }
  
  public func changeTitle(text: String) {
    self.setTitle(text, for: UIControl.State.normal)
  }
}

// MARK: - private functions

extension ToDoGardenBoxButton {
  private func setup(title: String, configuration: Configuration) {
    if configuration.dataStore.mode == Constant.ToDoGardenBoxButton.Mode.roundRectangle {
      self.setupCornerRadius(with: configuration.dataStore.size.height / 2)
    }
    
    self.updateBackgroundColor()
    self.setTitle(title, for: UIControl.State.normal)
    self.setupTitleFont()
    self.setupActionToChangeAlpha(with: configuration)
  }
  
  private func setupTitleFont() {
    self.titleLabel?.font = UIFont.pretendardHeadBold
  }
  
  private func setupCornerRadius(with value: CGFloat) {
    self.layer.cornerRadius = value
  }
  
  private func setupActionToChangeAlpha(with configuration: Configuration) {
    let highlightedAlpha = configuration.dataStore.highlightedAlpha
    let normalAlpha = configuration.dataStore.normalAlpha

    self.setupTouchDownAction(with: highlightedAlpha)
    self.setupTouchUpAction(with: normalAlpha)
  }
  
  private func setupTouchDownAction(with alpha: CGFloat) {
    let touchDownAction = UIAction { [weak self] _ in
      self?.alpha = alpha
    }
    
    self.addAction(touchDownAction, for: UIControl.Event.touchDown)
  }
  
  private func setupTouchUpAction(with alpha: CGFloat) {
    let touchUpAction = UIAction { [weak self] _ in
      self?.alpha = alpha
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

extension ToDoGardenBoxButton {
  public struct Configuration {
    let dataStore: Constant.ToDoGardenBoxButton.DataStore
    
    init(dataStore: Constant.ToDoGardenBoxButton.DataStore) {
      self.dataStore = dataStore
    }
  }
}

extension ToDoGardenBoxButton.Configuration {
  public static let primaryRoundRectButton: Self = 
  ToDoGardenBoxButton.Configuration.init(dataStore: Constant.ToDoGardenBoxButton.primaryRoundRectButton)
  
  public static let secondaryRoundRectButton: Self = 
  ToDoGardenBoxButton.Configuration.init(dataStore: Constant.ToDoGardenBoxButton.secondaryRoundRectButton)
  
  public static let tertiaryRoundRectButton: Self = 
  ToDoGardenBoxButton.Configuration.init(dataStore: Constant.ToDoGardenBoxButton.tertiaryRoundRectButton)
  
  public static let rectangleButton: Self = 
  ToDoGardenBoxButton.Configuration.init(dataStore: Constant.ToDoGardenBoxButton.rectangleButton)
}
