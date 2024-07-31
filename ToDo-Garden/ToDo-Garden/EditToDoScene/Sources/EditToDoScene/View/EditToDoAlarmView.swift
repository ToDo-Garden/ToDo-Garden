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

// MARK: Set up Subviews Action

extension EditToDoAlarmView: AlarmTimeViewDelegate {
  func setupSwitchAction(_ closure: @escaping () -> Void) {
    let switchAction = UIAction { _ in
      closure()
    }

    self.alarmSwitch.addAction(switchAction, for: UIControl.Event.valueChanged)
  }

  /// 알림 시간 설정 버튼이 눌렸을 때 호출되는 메서드입니다.
  /// 상위 뷰에 이벤트 발생 여부를 전달합니다. (구현 예정)
  func didSelectAlarmTimeSettingButton() {

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
    self.setupSubviewDelegate()
    self.addSubviews()
    self.setupConstraints()
  }

  private func setupAlarmLabelUI() {
    self.alarmLabel.font = UIFont.pretendardHeadSemiBold
    let text = EditToDoSceneTheme.StringLiteral.ToDoScheduleView.AlarmLabel.text
    self.alarmLabel.text = text
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

#if DEBUG
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
#endif
