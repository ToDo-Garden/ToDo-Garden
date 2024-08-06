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
}
