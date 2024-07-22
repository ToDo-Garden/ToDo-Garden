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
  private let alarmTimeSettingView: AlarmTimeView

  init() {
    self.alarmSwitch = ToDoGardenSwitch(model: ToDoGardenSwitch.Model.primary)
    self.alarmLabel = UILabel()
    self.alarmTimeSettingView = AlarmTimeView(model: AlarmTimeView.Model.primary)
    super.init(frame: CGRect.zero)
    self.setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func enableAlarm() {
    self.alarmSwitch.setOn(true, animated: true)
    self.alarmTimeSettingView.enable()
  }

  func disableAlarm() {
    self.alarmSwitch.setOn(false, animated: true)
    self.alarmTimeSettingView.disable()
  }

  func updateAlarmTime(_ alarmTime: String) {
    self.alarmTimeSettingView.updateAlarmTime(with: alarmTime)
  }
}

// MARK: Set up Subviews Action

extension EditToDoAlarmView {
  func setupSwitchAction(_ closure: @escaping () -> Void) {
    let switchAction = UIAction { _ in
      closure()
    }

    self.alarmSwitch.addAction(switchAction, for: UIControl.Event.valueChanged)
  }

  func setupAlarmSettingAction(_ closure: @escaping () -> Void) {
    self.alarmTimeSettingView.addAlarmSettingAction(closure)
  }
}

// MARK: Theme Color

extension EditToDoAlarmView {
  func updateThemeColor(to newColor: UIColor) {
    self.alarmLabel.textColor = newColor
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
    self.addSubview(self.alarmTimeSettingView)
  }

  private func setupConstraints() {
    self.setupAlarmSwitchConstraints()
    self.setupAlarmLabelConstraints()
    self.setupAlarmTimeSettingViewConstraints()
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

    let layout = EditToDoViewController.Constant.Layout.EditToDoScheduleView.AlarmLabel.self
    NSLayoutConstraint.activate(
      [
        self.alarmLabel.leadingAnchor.constraint(
          equalTo: self.leadingAnchor,
          constant: layout.leadingMargin
        ),
        self.alarmLabel.centerYAnchor.constraint(equalTo: self.alarmSwitch.centerYAnchor)
      ]
    )
  }

  private func setupAlarmTimeSettingViewConstraints() {
    self.alarmTimeSettingView.usingAutolayout()

    let layout = EditToDoViewController.Constant.Layout.EditToDoScheduleView.AlarmTimeSettingView.self
    NSLayoutConstraint.activate(
      [
        self.alarmTimeSettingView.topAnchor.constraint(
          equalTo: self.alarmSwitch.bottomAnchor,
          constant: layout.topMargin
        ),
        self.alarmTimeSettingView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        self.alarmTimeSettingView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        self.alarmTimeSettingView.heightAnchor.constraint(equalToConstant: layout.height)
      ]
    )
  }
}

@available(iOS 17.0, *)
#Preview {
  let view = EditToDoAlarmView()
  view.setupSwitchAction {
    print("switch action called")
  }
  view.enableAlarm()
  view.disableAlarm()
  return view
}
