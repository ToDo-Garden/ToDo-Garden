//
//  ToDoCheckBoxButton.swift
//
//
//  Created by Wood on 5/2/24.
//

import AVFoundation
import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

public final class ToDoCheckBoxButton: UIButton {
  private var checkBoxModel: ToDoCheckBoxButton.CheckBoxModel
  private var impactGenerator: UIImpactFeedbackGenerator

  public init(checkBoxModel: ToDoCheckBoxButton.CheckBoxModel) {
    self.impactGenerator = UIImpactFeedbackGenerator(
      style: UIImpactFeedbackGenerator.FeedbackStyle.heavy
    )
    self.checkBoxModel = checkBoxModel
    super.init(frame: CGRect.zero)
    self.updateState()
  }

  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Private Functions

extension ToDoCheckBoxButton {
  private func updateState() {
    if self.checkBoxModel.isToDoDone {
      self.completeToDo()
    } else {
      self.resetToDo()
    }
  }

  private func completeToDo() {
    self.isSelected = true
    self.backgroundColor = self.checkBoxModel.groupColor
    self.impactGenerator.impactOccurred(intensity: Constant.ToDoCheckBoxButton.Action.impactIntesity)
  }

  private func resetToDo() {
    self.isSelected = false
    self.backgroundColor = UIColor.toDoGardenWhite
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
