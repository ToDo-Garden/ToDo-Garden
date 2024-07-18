//
//  EditToDoAlarmView.swift
//
//
//  Created by Wood on 7/18/24.
//

import UIKit

import ToDoGardenUIComponent

final class EditToDoAlarmView: UIView {
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

extension EditToDoAlarmView {
  private func setup() {
    self.setupAlarmLabelUI()
    self.addSubviews()
    self.setupConstraints()
  }

  private func setupAlarmLabelUI() {
    self.alarmLabel.font = UIFont.pretendardHeadSemiBold
    let text = EditToDoSceneTheme.StringLiteral.ToDoScheduleView.AlarmLabel.text
    self.alarmLabel.text = text
  }
}

// MARK: Auto Layout

extension EditToDoAlarmView {
  private func addSubviews() {
    self.addSubview(self.alarmSwitch)
    self.addSubview(self.alarmLabel)
  }

  private func setupConstraints() {
    self.setupAlarmSwitchConstraints()
    self.setupAlarmLabelConstraints()
  }

  private func setupAlarmSwitchConstraints() {
    self.alarmSwitch.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.alarmSwitch.topAnchor.constraint(equalTo: self.topAnchor),
        self.alarmSwitch.trailingAnchor.constraint(
          equalTo: self.trailingAnchor,
          constant: -2
        )
      ]
    )
  }

  private func setupAlarmLabelConstraints() {
    self.alarmLabel.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.alarmLabel.leadingAnchor.constraint(
          equalTo: self.leadingAnchor,
          constant: 4
        ),
        self.alarmLabel.centerYAnchor.constraint(equalTo: self.alarmSwitch.centerYAnchor)
      ]
    )
  }
}
