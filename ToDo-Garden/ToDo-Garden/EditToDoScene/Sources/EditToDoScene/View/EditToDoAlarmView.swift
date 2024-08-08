//
//  EditToDoAlarmView.swift
//
//
//  Created by Wood on 7/18/24.
//

import UIKit

import ToDoGardenUIAPI
import ToDoGardenUIComponent

final class EditToDoAlarmView: UIView {
  private let alarmSwitch: ToDoGardenSwitch
  private let alarmLabel: UILabel
  private let alarmTimeSettingView: AlarmTimeView

  weak var delegate: EditToDoAlarmViewDelegate?

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

  /// 해당 메서드는 서버로 부터 받아온 투두 정보를 바탕으로 알림 스위치를 활성화시키는 메서드입니다.
  /// 사용자가 기존에 알림을 비활성화 했었을 경우에 호출합니다.
  func enableAlarm() {
    self.alarmSwitch.setOn(true, animated: true)
    self.alarmTimeSettingView.enable()
  }

  /// 해당 메서드는 서버로 부터 받아온 투두 정보를 바탕으로 알림 스위치를 비활성화시키는 메서드입니다.
  /// 사용자가 기존에 알림을 비활성화 했었을 경우에 호출합니다.
  func disableAlarm() {
    self.alarmSwitch.setOn(false, animated: true)
    self.alarmTimeSettingView.disable()
  }

  func updateAlarmTime(_ alarmTime: String) {
    self.alarmTimeSettingView.updateAlarmTime(with: alarmTime)
  }
}

// MARK: EditToDoAlarmView Delegate

protocol EditToDoAlarmViewDelegate: AnyObject {
  func didToggleSwitch()
  func didSelectAlarmSettingButton()
}

// MARK: AlarmTimeView Delegate Functions

extension EditToDoAlarmView: AlarmTimeViewDelegate {
  func didSelectAlarmTimeSettingButton() {
    self.delegate?.didSelectAlarmSettingButton()
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
    self.setupAlarmSwitchAction()
    self.setupSubviewDelegate()
    self.addSubviews()
    self.setupConstraints()
  }

  private func setupAlarmLabelUI() {
    self.alarmLabel.font = UIFont.pretendardHeadSemiBold
    let text = EditToDoSceneTheme.StringLiteral.ToDoScheduleView.AlarmLabel.text
    self.alarmLabel.text = text
    self.alarmLabel.textColor = EditToDoSceneTheme.mainColor
  }

  private func setupAlarmSwitchAction() {
    let switchAction = UIAction { _ in
      self.delegate?.didToggleSwitch()
    }

    self.alarmSwitch.addAction(switchAction, for: UIControl.Event.valueChanged)
  }

  private func setupSubviewDelegate() {
    self.alarmTimeSettingView.delegate = self
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
        self.alarmSwitch.trailingAnchor.constraint(equalTo: self.alarmTimeSettingView.trailingAnchor)
      ]
    )
  }

  private func setupAlarmLabelConstraints() {
    self.alarmLabel.usingAutolayout()

    let layout = EditToDoViewController.Constant.Layout.EditToDoScheduleView.EditToDoAlarmView.self
    NSLayoutConstraint.activate(
      [
        self.alarmLabel.leadingAnchor.constraint(
          equalTo: self.alarmTimeSettingView.leadingAnchor,
          constant: layout.AlarmLabel.leadingMargin
        ),
        self.alarmLabel.centerYAnchor.constraint(equalTo: self.alarmSwitch.centerYAnchor)
      ]
    )
  }

  private func setupAlarmTimeSettingViewConstraints() {
    self.alarmTimeSettingView.usingAutolayout()

    let layout = EditToDoViewController.Constant.Layout.EditToDoScheduleView.EditToDoAlarmView.self
    NSLayoutConstraint.activate(
      [
        self.alarmTimeSettingView.topAnchor.constraint(
          equalTo: self.alarmSwitch.bottomAnchor,
          constant: layout.AlarmTimeSettingView.topMargin
        ),
        self.alarmTimeSettingView.leadingAnchor.constraint(
          equalTo: self.leadingAnchor,
          constant: layout.AlarmTimeSettingView.leadingMargin
        ),
        self.alarmTimeSettingView.trailingAnchor.constraint(
          equalTo: self.trailingAnchor,
          constant: -layout.AlarmTimeSettingView.trailingMargin
        ),
        self.alarmTimeSettingView.heightAnchor.constraint(
          equalToConstant: layout.AlarmTimeSettingView.height
        )
      ]
    )
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let view = EditToDoAlarmView()
  view.enableAlarm()
  view.disableAlarm()
  return view
}
#endif
