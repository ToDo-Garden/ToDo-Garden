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

  init() {
    self.alarmSwitch = ToDoGardenSwitch(model: ToDoGardenSwitch.Model.primary)
    super.init(frame: CGRect.zero)
    self.setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension EditToDoAlarmView {
  private func setup() {
    self.addSubviews()
    self.setupConstraints()
  }
}

extension EditToDoAlarmView {
  private func addSubviews() {
    self.addSubview(self.alarmSwitch)
  }

  private func setupConstraints() {
    self.setupAlarmSwitchConstraints()
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
}
