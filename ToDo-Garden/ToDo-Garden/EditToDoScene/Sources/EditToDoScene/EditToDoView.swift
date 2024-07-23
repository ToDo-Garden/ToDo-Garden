//
//  EditToDoView.swift
//
//
//  Created by Wood on 7/22/24.
//

import UIKit

import ToDoGardenUIAPI

final class EditToDoView: UIView {
  private let toDoNameInputView: TextInputViewAPI

  init(textInputView: TextInputViewAPI) {
    self.toDoNameInputView = textInputView
    super.init(frame: CGRect.zero)
    self.setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Private Functions

extension EditToDoView {
  private func setup() {
    self.setupSubviewsLayout()
  }
}

// MARK: About Layout

extension EditToDoView {
  private func setupSubviewsLayout() {
    self.setupToDoNameInputViewLayout()
  }

  private func setupToDoNameInputViewLayout() {
    self.addSubview(self.toDoNameInputView)
    self.toDoNameInputView.translatesAutoresizingMaskIntoConstraints = false

    let layout = EditToDoViewController.Constant.Layout.EditToDoView.ToDoNameTextInputView.self
    NSLayoutConstraint.activate(
      [
        self.toDoNameInputView.topAnchor.constraint(
          equalTo: self.topAnchor,
          constant: layout.topMargin
        ),
        self.toDoNameInputView.leadingAnchor.constraint(
          equalTo: self.leadingAnchor,
          constant: layout.leadingMargin
        ),
        self.toDoNameInputView.trailingAnchor.constraint(
          equalTo: self.trailingAnchor,
          constant: -layout.trailingMargin
        ),
        self.toDoNameInputView.heightAnchor.constraint(equalToConstant: layout.height)
      ]
    )
  }
}
