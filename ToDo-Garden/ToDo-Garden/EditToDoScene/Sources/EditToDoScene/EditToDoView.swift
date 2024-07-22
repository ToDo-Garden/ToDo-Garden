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

  private func makeGroupLabel() -> UILabel {
    let groupLabel = UILabel()
    groupLabel.font = UIFont.pretendardHeadSemiBold
    groupLabel.textColor = EditToDoSceneTheme.mainColor
    groupLabel.text = EditToDoSceneTheme.StringLiteral.EditToDoView.GroupLabel.text
    return groupLabel
  }
}

// MARK: About Layout

extension EditToDoView {
  private func setupSubviewsLayout() {
    self.setupToDoNameInputViewLayout()
    self.setupGroupLabelLayout(label: self.makeGroupLabel())
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

  private func setupGroupLabelLayout(label: UILabel) {
    self.addSubview(label)
    label.usingAutolayout()

    let layout = EditToDoViewController.Constant.Layout.EditToDoView.GroupLabel.self
    NSLayoutConstraint.activate(
      [
        label.topAnchor.constraint(
          equalTo: self.toDoNameInputView.bottomAnchor,
          constant: layout.topMargin
        ),
        label.leadingAnchor.constraint(
          equalTo: self.leadingAnchor,
          constant: layout.leadingMargin
        )
      ]
    )
  }
}
