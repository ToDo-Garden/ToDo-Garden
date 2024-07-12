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
  private let alarmTimeSettingView: AlarmTimeView
  private let editToDoRepetitionView: EditToDoRepetitionView

  init() {
    self.alarmSwitch = ToDoGardenSwitch(model: ToDoGardenSwitch.Model.primary)
    self.alarmLabel = UILabel()
    self.alarmTimeSettingView = AlarmTimeView(model: AlarmTimeView.Model.primary)
    self.editToDoRepetitionView = EditToDoRepetitionView()
    super.init(frame: CGRect.zero)
    self.setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func updateAlarmTime(isAlarmOn: Bool = true, alarmTime: String?) {
    self.updateAlarmTimeSettingActivation(by: isAlarmOn)
    self.updateAlarmTimeSettingViewUI(alarmTime: alarmTime)
  }

  func updateRepetitionRange(
    isRepeatOnlyToday: Bool = true,
    startDay: String?,
    endDay: String?
  ) {
    self.editToDoRepetitionView.updateRepetitionUI(
      isRepeatOnlyToday: isRepeatOnlyToday,
      startDay: startDay,
      endDay: endDay
    )
  }

  func getToDoScheduleData() -> (Bool, Bool) {
    let isAlarmOn = self.alarmSwitch.isOn
    let isRepeatOnlyToday = self.editToDoRepetitionView.getIsRepeatOnlyToday()
    return (isAlarmOn, isRepeatOnlyToday)
  }
}

// MARK: Private Functions

extension EditToDoScheduleView {
  private func updateAlarmTimeSettingActivation(by isAlarmOn: Bool) {
    self.alarmSwitch.isOn = isAlarmOn

    if isAlarmOn {
      self.alarmTimeSettingView.enable()
    } else {
      self.alarmTimeSettingView.disable()
    }
  }

  private func updateAlarmTimeSettingViewUI(alarmTime: String?) {
    guard let alarmTime = alarmTime
    else { return }

    self.alarmTimeSettingView.updateAlarmTime(with: alarmTime)
  }

  private func setup() {
    self.setupAlarmLabelUI()
    self.setupAlarmSwitchAction()
    self.addSubviews()
    self.setupSubviewsLayout()
  }

  private func setupAlarmLabelUI() {
    self.alarmLabel.font = UIFont.pretendardHeadSemiBold
    self.alarmLabel.textColor = EditToDoSceneTheme.mainColor
    self.alarmLabel.text = EditToDoSceneTheme.StringLiteral.ToDoScheduleView.AlarmLabel.text
  }

  private func setupAlarmSwitchAction() {
    let action = UIAction { [weak self] _ in
      guard let self else { return }

      if self.alarmSwitch.isOn {
        self.alarmTimeSettingView.enable()
      } else {
        self.alarmTimeSettingView.disable()
      }
    }

    self.alarmSwitch.addAction(action, for: UIControl.Event.valueChanged)
  }
}

// MARK: About Layout

extension EditToDoScheduleView {
  private func addSubviews() {
    self.addSubview(self.alarmSwitch)
    self.addSubview(self.alarmLabel)
    self.addSubview(self.alarmTimeSettingView)
    self.addSubview(self.editToDoRepetitionView)
  }

  private func setupSubviewsLayout() {
    self.setupAlarmSwitchLayout()
    self.setupAlarmLabelLayout()
    self.setupAlarmTimeSettingViewLayout()
    self.setupEditToDoRepetitionViewLayout()
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

  private func setupAlarmTimeSettingViewLayout() {
    self.alarmTimeSettingView.usingAutolayout()

    let layout = EditToDoViewController.Constant.Layout.EditToDoScheduleView.AlarmTimeSettingView.self
    NSLayoutConstraint.activate(
      [
        self.alarmTimeSettingView.topAnchor.constraint(
          equalTo: self.alarmSwitch.bottomAnchor,
          constant: layout.topMargin
        ),
        self.alarmTimeSettingView.leadingAnchor.constraint(
          equalTo: self.leadingAnchor,
          constant: layout.leadingMargin
        ),
        self.alarmTimeSettingView.trailingAnchor.constraint(
          equalTo: self.trailingAnchor,
          constant: -layout.trailingMargin
        ),
        self.alarmTimeSettingView.heightAnchor.constraint(equalToConstant: layout.height)
      ]
    )
  }

  private func setupAlarmLabelLayout() {
    self.alarmLabel.usingAutolayout()

    let layout = EditToDoViewController.Constant.Layout.EditToDoScheduleView.AlarmLabel.self
    NSLayoutConstraint.activate(
      [
        self.alarmLabel.leadingAnchor.constraint(
          equalTo: self.alarmTimeSettingView.leadingAnchor,
          constant: layout.leadingMargin
        ),
        self.alarmLabel.centerYAnchor.constraint(equalTo: self.alarmSwitch.centerYAnchor)
      ]
    )
  }

  private func setupEditToDoRepetitionViewLayout() {
    self.editToDoRepetitionView.usingAutolayout()

    let layout = EditToDoViewController.Constant.Layout.EditToDoScheduleView.EditToDoRepetitionView.self
    NSLayoutConstraint.activate(
      [
        self.editToDoRepetitionView.topAnchor.constraint(
          equalTo: self.alarmTimeSettingView.bottomAnchor,
          constant: layout.topMargin
        ),
        self.editToDoRepetitionView.leadingAnchor.constraint(equalTo: self.alarmTimeSettingView.leadingAnchor),
        self.editToDoRepetitionView.trailingAnchor.constraint(equalTo: self.alarmTimeSettingView.trailingAnchor),
        self.editToDoRepetitionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
      ]
    )
  }
}
