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

  init() {
    self.repetitionLabel = UILabel()
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
  private func setup() {
    self.setupRepetitionLabelUI()
  }

  private func setupRepetitionLabelUI() {
    self.repetitionLabel.font = UIFont.pretendardHeadSemiBold
    self.repetitionLabel.textColor = EditToDoSceneTheme.mainColor
    let text = EditToDoSceneTheme.StringLiteral.ToDoScheduleView.AlarmLabel.text
    self.repetitionLabel.text = text
  }
}

// MARK: About Layout

extension EditToDoRepetitionView {
  private func addSubviews() {
    self.addSubview(self.repetitionLabel)
  }

  private func setupSubviewsLayout() {
    self.setupRepetitionLabelLayout()
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
}
