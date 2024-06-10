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
    self.setupThumbScale(with: model.thumbScale)
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

  private func setupThumbScale(with scale: CGFloat) {
    let defaultScale: CGFloat = 1.0
    guard scale != defaultScale
    else { return }

    if let thumbImageView = self.subviews.first?.subviews.last?.subviews.last as? UIImageView {
      thumbImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
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

// MARK: Preview

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  return ToDoGardenSwitch(model: .primary)
}
#endif
