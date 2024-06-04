//
//  EditToDoSegmentedControl.swift
//
//
//  Created by Noah on 6/3/24.
//

import UIKit

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
