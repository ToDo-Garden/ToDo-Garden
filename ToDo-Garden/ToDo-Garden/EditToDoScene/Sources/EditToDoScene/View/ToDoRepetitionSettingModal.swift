//
//  ToDoRepetitionSettingModal.swift
//
//
//  Created by Wood on 2/18/25.
//

import UIKit

import ToDoGardenUIComponent

final class ToDoRepetitionSettingModal: UIViewController {
  private let dateRangePicker: DateRangePicker
  private let completeButton: ToDoGardenBoxButton

  private var startDate: Date?
  private var endDate: Date?

  weak var delegate: ToDoRepetitionSettingModalDelegate?

  init(startDate: Date? = nil, endDate: Date? = nil) {
    self.dateRangePicker = DateRangePicker()
    self.completeButton = ToDoGardenBoxButton(
      title: "완료",
      buttonType: ToDoGardenBoxButton.Configuration.primaryRoundRectButton
    )
    self.startDate = startDate
    self.endDate = endDate
    super.init(nibName: nil, bundle: nil)
    self.setupPresentationStyle()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: View Life Cycle

extension ToDoRepetitionSettingModal {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
  }
}

extension ToDoRepetitionSettingModal {
  private func setupPresentationStyle() {
    if #available(iOS 16.0, *) {
      self.sheetPresentationController?.detents = [
        .custom { _ in return 500 }
      ]
    }
    self.sheetPresentationController?.prefersGrabberVisible = true
  }

  private func setup() {
    self.setupCompleteButton()
    self.setupCompleteButtonActivation()
    self.setupUI()
  }

  private func setupCompleteButton() {
    self.completeButton.isEnabled = (self.startDate != nil && self.endDate != nil)
    self.setupCompleteButtonActivation()
  }

  private func setupCompleteButtonActivation() {
    self.dateRangePicker.didChangeDateRange = { (start, end) in
      guard let start, let end else {
        self.completeButton.isEnabled = false
        return
      }

      self.completeButton.isEnabled = true
      self.startDate = start
      self.endDate = end
    }

    let action = UIAction { [weak self] _ in
      guard let self, let start = self.startDate, let end = self.endDate
      else { return }

      self.delegate?.didSelectRepetitionRange(start, end)
      self.dismiss(animated: true)
    }
    self.completeButton.addAction(action, for: UIControl.Event.touchUpInside)
  }
}

extension ToDoRepetitionSettingModal {
  private func setupUI() {
    self.setupBackgroundColor()
    self.setupDateRangePickerLayout()
    self.setupCompleteButtonLayout()
  }

  private func setupBackgroundColor() {
    self.view.backgroundColor = UIColor.toDoGardenWhite
  }

  private func setupDateRangePickerLayout() {
    self.view.addSubview(self.dateRangePicker)
    self.dateRangePicker.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.dateRangePicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        self.dateRangePicker.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        self.dateRangePicker.widthAnchor.constraint(equalToConstant: 336),
        self.dateRangePicker.heightAnchor.constraint(equalToConstant: 400)
      ]
    )
  }

  private func setupCompleteButtonLayout() {
    self.view.addSubview(self.completeButton)
    self.completeButton.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.completeButton.topAnchor.constraint(
          equalTo: self.dateRangePicker.bottomAnchor,
          constant: 0
        ),
        self.completeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
      ]
    )
  }
}

protocol ToDoRepetitionSettingModalDelegate: AnyObject {
  func didSelectRepetitionRange(_ startDate: Date, _ endDate: Date)
}
