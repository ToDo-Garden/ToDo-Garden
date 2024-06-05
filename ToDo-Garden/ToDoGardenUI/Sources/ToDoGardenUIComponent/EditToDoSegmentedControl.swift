//
//  EditToDoSegmentedControl.swift
//
//
//  Created by Noah on 6/3/24.
//

import UIKit

import ToDoGardenUIResource

public final class EditToDoSegmentedControl: UISegmentedControl {
  public enum EditMode: Int {
    case notification = 0
    case todo = 1
  }
  
  public var editMode: EditMode?
  
  public init() {
    super.init(frame: CGRect.zero)
    self.setup()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Setup

extension EditToDoSegmentedControl {
  private func setup() {
    self.setupAction()
    self.setupAppearance()
  }
}

// MARK: - Setup action

extension EditToDoSegmentedControl {
  private func setupAction() {
    self.addTarget(
      self,
      action: #selector(self.editModeDidChange(_:)),
      for: UIControl.Event.valueChanged
    )
  }
  
  @objc private func editModeDidChange(_ sender: UISegmentedControl) {
    guard let selectedMode = EditMode(rawValue: sender.selectedSegmentIndex)
    else {
      self.editMode = nil
      return
    }
    
    self.editMode = selectedMode
  }
}

// MARK: - Setup appearance

extension EditToDoSegmentedControl {
  private func setupAppearance() {
    let notificationEditImage = UIImage.bellIconImage.withRenderingMode(
      UIImage.RenderingMode.alwaysOriginal
    )
    let toDoEditImage = UIImage.editIconImage.withRenderingMode(
      UIImage.RenderingMode.alwaysOriginal
    )
    self.insertSegment(
      with: notificationEditImage,
      at: EditToDoSegmentedControl.EditMode.notification.rawValue,
      animated: false
    )
    self.insertSegment(
      with: toDoEditImage,
      at: EditToDoSegmentedControl.EditMode.todo.rawValue,
      animated: false
    )
    self.backgroundColor = UIColor.toDoGardenGreenBackground
    self.selectedSegmentTintColor = UIColor.white
    self.selectedSegmentIndex = EditToDoSegmentedControl.EditMode.todo.rawValue
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  return EditToDoSegmentedControl()
}
#endif
