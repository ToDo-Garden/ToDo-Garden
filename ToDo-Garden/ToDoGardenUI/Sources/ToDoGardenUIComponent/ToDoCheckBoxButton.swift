//
//  ToDoCheckBoxButton.swift
//
//
//  Created by Wood on 5/2/24.
//

import UIKit

import ToDoGardenUIResource
import ToDoGardenUIConstant

public final class ToDoCheckBoxButton: UIButton {
  private var checkBoxModel: ToDoCheckBoxButton.CheckBoxModel

  public init(checkBoxModel: ToDoCheckBoxButton.CheckBoxModel) {
    self.checkBoxModel = checkBoxModel
    super.init(frame: CGRect.zero)
  }

  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: CheckBox Model

extension ToDoCheckBoxButton {
  public struct CheckBoxModel {
    var isToDoDone: Bool
    var groupColor: UIColor
    var borderWidth: CGFloat
    var cornerRadius: CGFloat

    public init(
      isToDoDone: Bool,
      groupColor: UIColor,
      borderWidth: CGFloat = Constant.ToDoCheckBoxButton.Layout.borderWidth,
      cornerRadius: CGFloat = Constant.ToDoCheckBoxButton.Layout.cornerRadius
    ) {
      self.isToDoDone = isToDoDone
      self.groupColor = groupColor
      self.borderWidth = borderWidth
      self.cornerRadius = cornerRadius
    }
  }
}
