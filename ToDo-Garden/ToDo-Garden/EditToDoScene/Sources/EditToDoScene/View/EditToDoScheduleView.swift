//
//  EditToDoScheduleView.swift
//
//
//  Created by Wood on 7/11/24.
//

import UIKit

import ToDoGardenUIComponent

final class EditToDoScheduleView: UIView {
  private let editToDoAlarmView: EditToDoAlarmView
  private let editToDoRepetitionView: EditToDoRepetitionView

  init() {
    self.editToDoAlarmView = EditToDoAlarmView()
    self.editToDoRepetitionView = EditToDoRepetitionView()
    super.init(frame: CGRect.zero)
    self.setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func updateAlarmTime(alarmTime: String) {
    self.editToDoAlarmView.updateAlarmTime(alarmTime)
  }

  func updateToRepeatOnlyToday() {
    self.editToDoRepetitionView.setRepeatOnlyTodaySelected()
  }

  func updateToRepeatEveryday() {
    self.editToDoRepetitionView.setRepeatEverydaySelected()
  }

  func updateToRepeatInRange() {
    self.editToDoRepetitionView.setRepeatRangeSelected()
  }
}

// MARK: Delegate Functions

/// 하위 뷰들에서 이벤트를 입력받았을 때 Delegate로 전달받아 호출되는 메서드들입니다.
extension EditToDoScheduleView: EditToDoRepetitionViewDelegate, EditToDoAlarmViewDelegate {
  func didSelectOnlyTodayView(isOnlyToday: Bool) {}
  func didSelectEverydayButton(isSelected: Bool) {}

  func didToggleSwitch() {}
  func didSelectAlarmSettingButton() {}
}

// MARK: Private Functions

extension EditToDoScheduleView {
  private func setup() {
    self.setupDelegate()
    self.addSubviews()
    self.setupSubviewsLayout()
  }

  private func setupDelegate() {
    self.editToDoRepetitionView.delegate = self
    self.editToDoAlarmView.delegate = self
  }
}

// MARK: About Layout

extension EditToDoScheduleView {
  private func addSubviews() {
    self.addSubview(self.editToDoAlarmView)
    self.addSubview(self.editToDoRepetitionView)
  }

  private func setupSubviewsLayout() {
    self.setupEditToDoAlarmViewLayout()
    self.setupEditToDoRepetitionViewLayout()
  }

  private func setupEditToDoAlarmViewLayout() {
    self.editToDoAlarmView.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.editToDoAlarmView.topAnchor.constraint(equalTo: self.topAnchor),
        self.editToDoAlarmView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        self.editToDoAlarmView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        self.editToDoAlarmView.heightAnchor.constraint(equalToConstant: 92)
      ]
    )
  }

  private func setupEditToDoRepetitionViewLayout() {
    self.editToDoRepetitionView.usingAutolayout()

    let layout = EditToDoViewController.Constant.Layout.EditToDoScheduleView.EditToDoRepetitionView.self
    NSLayoutConstraint.activate(
      [
        self.editToDoRepetitionView.topAnchor.constraint(
          equalTo: self.editToDoAlarmView.bottomAnchor,
          constant: layout.topMargin
        ),
        self.editToDoRepetitionView.leadingAnchor.constraint(equalTo: self.editToDoAlarmView.leadingAnchor),
        self.editToDoRepetitionView.trailingAnchor.constraint(equalTo: self.editToDoAlarmView.trailingAnchor),
        self.editToDoRepetitionView.heightAnchor.constraint(equalToConstant: 231)
      ]
    )
  }
}

@available(iOS 17.0, *)
#Preview {
  let view = UIView()
  let scheduleView = EditToDoScheduleView()
  scheduleView.updateToRepeatEveryday()
  view.addSubview(scheduleView)
  scheduleView.usingAutolayout()
  scheduleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
  scheduleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
  scheduleView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true

  return view
}
