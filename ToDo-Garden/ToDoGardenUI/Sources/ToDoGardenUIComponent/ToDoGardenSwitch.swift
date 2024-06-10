//
//  ToDoGardenSwitch.swift
//
//
//  Created by SONG on 3/1/24.
//

import UIKit.UISwitch

import ToDoGardenUIConstant
import ToDoGardenUIResource

public final class ToDoGardenSwitch: UISwitch {
  public init(model: Model) {
    super.init(frame: CGRect.zero)
    self.setupOnTintColor()
  }
  
  public convenience init(isOn: Bool) {
    self.init(model: .primary)
    self.isOn = isOn
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.setupOnTintColor()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.setupOffTintColor()
  }
}

// MARK: - private functions

extension ToDoGardenSwitch {
  private func setupOnTintColor() {
    self.onTintColor = UIColor.toDoGardenGreenDark
  }
  
  private func setupOffTintColor() {
    let offBackgroundView = self.subviews.first?.subviews.first
    offBackgroundView?.backgroundColor = UIColor.toDoGardenGreenGray
  }
}

// MARK: Model

extension ToDoGardenSwitch {
  public struct Model {
    let thumbScale: CGFloat

    public init(thumbScale: CGFloat) {
      self.thumbScale = thumbScale
    }

    public static let primary = Self(thumbScale: Constant.ToDoGardenSwitch.Layout.thumbScale)
  }
}
