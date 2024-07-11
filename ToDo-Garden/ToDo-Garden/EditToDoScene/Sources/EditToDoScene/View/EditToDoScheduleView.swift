//
//  EditToDoScheduleView.swift
//
//
//  Created by Wood on 7/11/24.
//

import UIKit

import ToDoGardenUIComponent

final class EditToDoScheduleView: UIView {
  private let alarmSwitch: ToDoGardenSwitch
  private let alarmLabel: UILabel

  init() {
    self.alarmSwitch = ToDoGardenSwitch(model: ToDoGardenSwitch.Model.primary)
    self.alarmLabel = UILabel()
    super.init(frame: CGRect.zero)
    self.setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Private Functions

extension EditToDoScheduleView {
  private func setup() {
    self.setupAlarmLabelUI()
    self.addSubviews()
    self.setupSubviewsLayout()
  }

  private func setupAlarmLabelUI() {
    self.alarmLabel.font = UIFont.pretendardHeadSemiBold
    self.alarmLabel.textColor = EditToDoSceneTheme.mainColor
    self.alarmLabel.text = EditToDoSceneTheme.StringLiteral.ToDoScheduleView.AlarmLabel.text
  }
}

// MARK: About Layout

extension EditToDoScheduleView {
  private func addSubviews() {
    self.addSubview(self.alarmSwitch)
    self.addSubview(self.alarmLabel)
  }

  private func setupSubviewsLayout() {
    self.setupAlarmSwitchLayout()
  }

  private func setupAlarmSwitchLayout() {
    self.alarmSwitch.usingAutolayout()

    let layout = EditToDoViewController.Constant.Layout.EditToDoScheduleView.AlarmSwitch.self
    NSLayoutConstraint.activate(
      [
        self.alarmSwitch.topAnchor.constraint(
          equalTo: self.topAnchor,
          constant: layout.topMargin
        ),
        self.alarmSwitch.trailingAnchor.constraint(
          equalTo: self.trailingAnchor,
          constant: -layout.trailingMargin
        )
      ]
    )
  }
}
