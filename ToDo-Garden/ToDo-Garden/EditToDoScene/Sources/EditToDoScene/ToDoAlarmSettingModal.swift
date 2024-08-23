//
//  ToDoAlarmTimeSettingModal.swift
//
//
//  Created by Wood on 8/23/24.
//

import UIKit

import ToDoGardenUIComponent

extension EditToDoViewController {
  final class ToDoAlarmTimeSettingModal: UIViewController {
    private let completeButton: ToDoGardenBoxButton
    private let settingTimeView: SettingTimeView

    weak var delegate: ToDoAlarmTimeSettingModalDelegate?

    init() {
      self.completeButton = ToDoGardenBoxButton(
        title: EditToDoSceneTheme.StringLiteral.ToDoAlarmTimeSettingModal.buttonTitle,
        buttonType: ToDoGardenBoxButton.Configuration.primaryRoundRectButton
      )
      self.settingTimeView = SettingTimeView(
        with: self.completeButton,
        for: SettingTimeView.Configuration.alarmTimeSetting
      )
      super.init(nibName: nil, bundle: nil)
      self.setupPresentationStyle()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
      super.viewDidLoad()
      self.setup()
    }

    func updateInitialAlarmTime(hour: Int, minute: Int) {
      self.settingTimeView.updateSelectedTime(hour: hour, minute: minute)
    }
  }
}

protocol ToDoAlarmTimeSettingModalDelegate: AnyObject {
  func didSelectAlarmTime(_ alarmTime: Double)
}

extension EditToDoViewController.ToDoAlarmTimeSettingModal {
  private func setupPresentationStyle() {
    self.sheetPresentationController?.detents = [
      UISheetPresentationController.Detent.medium()
    ]
    self.sheetPresentationController?.prefersGrabberVisible = true
  }

  private func setup() {
    self.setupBackgroundColor()
    self.setupCompleteButtonAction()
    self.setupSettingTimeViewLayout()
  }

  private func setupBackgroundColor() {
    self.view.backgroundColor = UIColor.toDoGardenWhite
  }

  private func setupCompleteButtonAction() {
    let buttonAction = UIAction { _ in
      self.settingTimeView.transformSeconds { (alarmTime: Double) in
        self.delegate?.didSelectAlarmTime(alarmTime)
        self.dismiss(animated: true)
      }
    }

    self.completeButton.addAction(buttonAction, for: UIControl.Event.touchUpInside)
  }

  private func setupSettingTimeViewLayout() {
    self.view.addSubview(self.settingTimeView)
    self.settingTimeView.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.settingTimeView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        self.settingTimeView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
      ]
    )
  }
}
