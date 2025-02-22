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

  weak var delegate: EditToDoRepetitionViewDelegate?

  init() {
    self.repetitionLabel = UILabel()
    self.repeatOnlyTodayView = ToDoRepeatSelectionView(model: ToDoRepeatSelectionView.Model.onlyToday)
    self.repeatOtherDaysView = RepeatOtherDaysView(startDate: nil, endDate: nil)
    super.init(frame: CGRect.zero)
    self.setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setRepeatOnlyTodaySelected() {
    self.repeatOnlyTodayView.setSelected()
    self.repeatOtherDaysView.setDeSelected()
  }

  func setRepeatRangeSelected() {
    self.setRepeatOtherDaysViewSelected()
    self.repeatOtherDaysView.updateDateButtonState(isSelected: true)
  }

  func updateRepetitionRange(startDay: String, endDay: String) {
    self.repeatOtherDaysView.updateDate(startDate: startDay, endDate: endDay)
  }
}

// MARK: EditToDoRepetitionView Delegate

protocol EditToDoRepetitionViewDelegate: AnyObject {
  func didSelectOnlyTodayView(isOnlyToday: Bool)
  func didSelectRepetitionDateButton()
}

// MARK: Private Functions

extension EditToDoRepetitionView {
  private func setRepeatOtherDaysViewSelected() {
    self.repeatOnlyTodayView.setDeSelected()
    self.repeatOtherDaysView.setSelected()
  }

  private func setup() {
    self.setupRepetitionLabelUI()
    self.setupRepeatOnlyTodayViewDelegate()
    self.setupRepeatOtherDaysViewSelected()
    self.addSubviews()
    self.setupSubviewsLayout()
  }

  private func setupRepetitionLabelUI() {
    self.repetitionLabel.font = UIFont.pretendardHeadSemiBold
    self.repetitionLabel.textColor = EditToDoSceneTheme.mainColor
    let text = EditToDoSceneTheme.StringLiteral.ToDoScheduleView.RepetitionLabel.text
    self.repetitionLabel.text = text
  }

  private func setupRepeatOnlyTodayViewDelegate() {
    self.repeatOnlyTodayView.bindTapGesture { _ in
      let isOnlyToday = true
      self.delegate?.didSelectOnlyTodayView(isOnlyToday: isOnlyToday)
    }

    self.repeatOtherDaysView.bindTapGesture { _ in
      let isOnlyToday = false
      self.delegate?.didSelectOnlyTodayView(isOnlyToday: isOnlyToday)
    }
  }

  private func setupRepeatOtherDaysViewSelected() {
    let action = UIAction { [weak self] _ in
      self?.delegate?.didSelectRepetitionDateButton()
    }

    self.repeatOtherDaysView.setupDateSelectionButtonAction(action)
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
          equalTo: self.repeatOnlyTodayView.leadingAnchor,
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
          constant: layout.RepeatOnlyTodayView.topMargin
        ),
        self.repeatOnlyTodayView.leadingAnchor.constraint(
          equalTo: self.leadingAnchor,
          constant: layout.RepeatOnlyTodayView.leadingMargin
        ),
        self.repeatOnlyTodayView.trailingAnchor.constraint(
          equalTo: self.trailingAnchor,
          constant: -layout.RepeatOnlyTodayView.trailingMargin
        )
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
        self.repeatOtherDaysView.leadingAnchor.constraint(equalTo: self.repeatOnlyTodayView.leadingAnchor),
        self.repeatOtherDaysView.trailingAnchor.constraint(equalTo: self.repeatOnlyTodayView.trailingAnchor)
      ]
    )
  }
}
