//
//  EditToDoViewController+setupSubviewsLayout.swift
//
//
//  Created by Wood on 8/5/24.
//

import UIKit

extension EditToDoViewController {
  func setupSubviewsLayout() {
    self.setupEditToDoSegmentedControlLayout()
    self.setupEditModeScrollViewLayout()
  }

  private func setupEditToDoSegmentedControlLayout() {
    self.view.addSubview(self.editToDoSegmentedControl)
    self.editToDoSegmentedControl.translatesAutoresizingMaskIntoConstraints = false

    let constant = EditToDoViewController.Constant.Layout.EditModeSegmentedControl.self
    NSLayoutConstraint.activate(
      [
        self.editToDoSegmentedControl.topAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.topAnchor,
          constant: constant.topMargin
        ),
        self.editToDoSegmentedControl.leadingAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,
          constant: constant.leadingMargin
        ),
        self.editToDoSegmentedControl.trailingAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
          constant: -constant.trailingMargin
        ),
        self.editToDoSegmentedControl.heightAnchor.constraint(
          equalToConstant: constant.height
        )
      ]
    )
  }

  private func setupEditModeScrollViewLayout() {
    self.view.addSubview(self.editModeScrollView)
    self.editModeScrollView.translatesAutoresizingMaskIntoConstraints = false

    let constant = EditToDoViewController.Constant.Layout.EditModeScrollView.self
    NSLayoutConstraint.activate(
      [
        self.editModeScrollView.topAnchor.constraint(
          equalTo: self.editToDoSegmentedControl.bottomAnchor,
          constant: constant.topMargin
        ),
        self.editModeScrollView.leadingAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,
          constant: constant.leadingMargin
        ),
        self.editModeScrollView.trailingAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
          constant: -constant.trailingMargin
        ),
        self.editModeScrollView.bottomAnchor.constraint(
          equalTo: self.completeEditButton.topAnchor
        )
      ]
    )
  }
}
