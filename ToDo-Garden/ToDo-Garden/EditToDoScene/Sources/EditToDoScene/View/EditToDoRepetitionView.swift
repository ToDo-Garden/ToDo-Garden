//
//  EditToDoRepetitionView.swift
//
//
//  Created by Wood on 7/11/24.
//

import UIKit

import ToDoGardenUIComponent

final class EditToDoRepetitionView: UIView {
  private let repetitionLabel: UILabel
  private let repeatOnlyTodayView: ToDoRepeatSelectionView
  private let repeatOtherDaysView: RepeatOtherDaysView
  private var isRepeatOnlyToday: Bool {
    willSet { self.updateRepeatOnlyTodayViewUI(isRepeatOnlyToday: newValue) }
  }
  private var isRepeatOtherDays: Bool {
    willSet { self.updateRepeatOtherDaysViewUI(isRepeatOtherDays: newValue) }
  }

  init() {
    self.repetitionLabel = UILabel()
    self.repeatOnlyTodayView = ToDoRepeatSelectionView(model: ToDoRepeatSelectionView.Model.onlyToday)
    self.repeatOtherDaysView = RepeatOtherDaysView(startDate: nil, endDate: nil)
    self.isRepeatOnlyToday = true
    self.isRepeatOtherDays = false
    super.init(frame: CGRect.zero)
    self.setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Private Functions

extension EditToDoRepetitionView {
  private func updateRepeatOnlyTodayViewUI(isRepeatOnlyToday: Bool) {
    if isRepeatOnlyToday {
      self.repeatOnlyTodayView.setSelected()
    } else {
      self.repeatOnlyTodayView.setDeSelected()
    }
  }

  private func updateRepeatOtherDaysViewUI(isRepeatOtherDays: Bool) {
    if isRepeatOtherDays {
      self.repeatOtherDaysView.setSelected()
    } else {
      self.repeatOtherDaysView.setDeSelected()
    }
  }

  private func setup() {
    self.setupRepetitionLabelUI()
    self.setRepeatOnlyTodayViewSelected()
    self.addSubviews()
    self.setupSubviewsLayout()
  }

  private func setupRepetitionLabelUI() {
    self.repetitionLabel.font = UIFont.pretendardHeadSemiBold
    self.repetitionLabel.textColor = EditToDoSceneTheme.mainColor
    let text = EditToDoSceneTheme.StringLiteral.ToDoScheduleView.AlarmLabel.text
    self.repetitionLabel.text = text
  }

  private func setRepeatOnlyTodayViewSelected() {
    self.repeatOnlyTodayView.setSelected()
  }
}

// MARK: About Layout

extension EditToDoRepetitionView {
  private func addSubviews() {
    self.addSubview(self.repetitionLabel)
    self.addSubview(self.repeatOnlyTodayView)
    self.addSubview(self.repeatOtherDaysView)
  }

  private func setupSubviewsLayout() {
    self.setupRepetitionLabelLayout()
    self.setupRepeatOnlyTodayViewLayout()
    self.setupRepeatOtherDaysViewLayout()
  }

  private func setupRepetitionLabelLayout() {
    self.repetitionLabel.usingAutolayout()

    let layout = EditToDoViewController.Constant.Layout.EditToDoScheduleView.EditToDoRepetitionView.self
    NSLayoutConstraint.activate(
      [
        self.repetitionLabel.topAnchor.constraint(equalTo: self.topAnchor),
        self.repetitionLabel.leadingAnchor.constraint(
          equalTo: self.leadingAnchor,
          constant: layout.RepetitionLabel.leadingMargin
        )
      ]
    )
  }

  private func setupRepeatOnlyTodayViewLayout() {
    self.repeatOnlyTodayView.usingAutolayout()

    let layout = EditToDoViewController.Constant.Layout.EditToDoScheduleView.EditToDoRepetitionView.self
    NSLayoutConstraint.activate(
      [
        self.repeatOnlyTodayView.topAnchor.constraint(
          equalTo: self.repetitionLabel.bottomAnchor,
          constant: layout.RepeatOnlyTodayButton.topMargin
        ),
        self.repeatOnlyTodayView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        self.repeatOnlyTodayView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
      ]
    )
  }

  private func setupRepeatOtherDaysViewLayout() {
    self.repeatOtherDaysView.usingAutolayout()

    let layout = EditToDoViewController.Constant.Layout.EditToDoScheduleView.EditToDoRepetitionView.self
    NSLayoutConstraint.activate(
      [
        self.repeatOtherDaysView.topAnchor.constraint(
          equalTo: self.repeatOnlyTodayView.bottomAnchor,
          constant: layout.RepeatOtherDaysView.topMargin
        ),
        self.repeatOtherDaysView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        self.repeatOtherDaysView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
      ]
    )
  }

}
