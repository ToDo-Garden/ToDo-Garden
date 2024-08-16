//
//  EditToDoViewController+setup.swift
//
//
//  Created by Wood on 8/5/24.
//

import UIKit

import ToDoGardenUIComponent

extension EditToDoViewController {
  func setup() {
    self.setupUI()
    self.setupEditModeScrollView()
    self.setupEditModeSegmentedControlAction()
    self.setupSubviewsLayout()
  }

  private func setupUI() {
    self.title = EditToDoSceneTheme.StringLiteral.EditToDoViewController.title
    self.view.backgroundColor = UIColor.toDoGardenWhite
  }

  private func setupEditModeScrollView() {
    self.editModeScrollView.showsVerticalScrollIndicator = false
    self.editModeScrollView.showsHorizontalScrollIndicator = false
    self.editModeScrollView.isPagingEnabled = true
    self.editModeScrollView.delegate = self
    self.editModeScrollView.bounces = false
  }

  private func setupEditModeSegmentedControlAction() {
    let segmentedControlAction = UIAction { _ in
      if let editMode = self.editToDoSegmentedControl.editMode {
        self.changeEditMode(by: editMode)
      }
    }

    self.editToDoSegmentedControl.addAction(segmentedControlAction, for: UIControl.Event.valueChanged)
  }

  private func changeEditMode(by editMode: EditToDoSegmentedControl.EditMode) {
    let editModeType = EditToDoSegmentedControl.EditMode.self
    let pointX = editMode == editModeType.notification ? 0 : self.editModeScrollView.frame.width
    let contentOffset = CGPoint(x: pointX, y: 0)
    self.editModeScrollView.setContentOffset(contentOffset, animated: true)
  }

  private func setupCompleteEditButtonAction() {
    let editAction = UIAction { _ in
      self.editToDo()
    }

    self.completeEditButton.addAction(editAction, for: UIControl.Event.touchUpInside)
  }

  private func setupSubviewsLayout() {
    self.setupEditToDoSegmentedControlLayout()
    self.setupCompleteEditButtonLayout()
    self.setupEditModeScrollViewLayout()
    let contentView = self.buildEditModeScrollContentView()
    self.setupEditToDoViewLayout(with: contentView)
    self.setupEditToDoScheduleViewLayout(with: contentView)
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

  private func setupCompleteEditButtonLayout() {
    self.view.addSubview(self.completeEditButton)
    self.completeEditButton.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        self.completeEditButton.bottomAnchor.constraint(
          equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
          constant: -EditToDoViewController.Constant.Layout.CompleteEditingButton.bottomMargin
        ),
        self.completeEditButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
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

  private func buildEditModeScrollContentView() -> UIView {
    let contentView = UIView()
    contentView.addSubview(self.editToDoView)
    contentView.addSubview(self.editToDoScheduleView)
    self.setupContentViewLayout(contentView: contentView)
    return contentView
  }

  private func setupContentViewLayout(contentView: UIView) {
    self.editModeScrollView.addSubview(contentView)
    contentView.translatesAutoresizingMaskIntoConstraints = false

    let widthConstraint = self.editModeScrollView.widthAnchor.constraint(greaterThanOrEqualTo: self.view.widthAnchor)
    widthConstraint.priority = UILayoutPriority.defaultLow
    widthConstraint.isActive = true

    NSLayoutConstraint.activate(
      [
        contentView.topAnchor.constraint(equalTo: self.editModeScrollView.contentLayoutGuide.topAnchor),
        contentView.leadingAnchor.constraint(equalTo: self.editModeScrollView.contentLayoutGuide.leadingAnchor),
        contentView.trailingAnchor.constraint(equalTo: self.editModeScrollView.contentLayoutGuide.trailingAnchor),
        contentView.bottomAnchor.constraint(equalTo: self.editModeScrollView.contentLayoutGuide.bottomAnchor),
        contentView.heightAnchor.constraint(equalTo: self.editModeScrollView.heightAnchor)
      ]
    )
  }

  private func setupEditToDoViewLayout(with contentView: UIView) {
    self.editToDoView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        self.editToDoView.topAnchor.constraint(equalTo: contentView.topAnchor),
        self.editToDoView.leadingAnchor.constraint(equalTo: self.editToDoScheduleView.trailingAnchor),
        self.editToDoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        self.editToDoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        self.editToDoView.widthAnchor.constraint(equalTo: self.editModeScrollView.frameLayoutGuide.widthAnchor)
      ]
    )
  }

  private func setupEditToDoScheduleViewLayout(with contentView: UIView) {
    self.editToDoScheduleView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(
      [
        self.editToDoScheduleView.topAnchor.constraint(equalTo: contentView.topAnchor),
        self.editToDoScheduleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        self.editToDoScheduleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        self.editToDoScheduleView.widthAnchor.constraint(equalTo: self.editModeScrollView.frameLayoutGuide.widthAnchor)
      ]
    )
  }
}
