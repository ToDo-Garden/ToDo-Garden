//
//  CalendarCollectionViewCell.swift
//
//
//  Created by Wood on 5/31/24.
//

import UIKit

import ToDoGardenUIConstant

final class CalendarCollectionViewCell: UICollectionViewCell {
  private var toDoExistenceView: UIView

  override init(frame: CGRect) {
    self.toDoExistenceView = UIView()
    super.init(frame: CGRect.zero)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Private Functions

extension CalendarCollectionViewCell {
  private func setup() {
    self.setupToDoExistenceView()
    self.addSubviews()
    self.setupSubviewsLayout()
  }

  private func setupToDoExistenceView() {
    self.toDoExistenceView.backgroundColor = UIColor.toDoGardenGray3
    let cornerRadius = Constant.CalendarView.Layout.CollectionViewCell.ToDoExistenceView.cornerRadius
    self.toDoExistenceView.layer.cornerRadius = cornerRadius
    self.toDoExistenceView.isHidden = true
  }
}

// MARK: Set AutoLayout

extension CalendarCollectionViewCell {
  private func addSubviews() {
    self.addSubview(self.toDoExistenceView)
  }

  private func setupSubviewsLayout() {
    self.setupToDoExistenceViewLayout()
  }

  private func setupToDoExistenceViewLayout() {
    self.toDoExistenceView.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.toDoExistenceView.leadingAnchor.constraint(equalTo: self.dayLabel.leadingAnchor),
        self.toDoExistenceView.bottomAnchor.constraint(equalTo: self.dayLabel.topAnchor),
        self.toDoExistenceView.widthAnchor.constraint(
          equalToConstant: Constant.CalendarView.Layout.CollectionViewCell.ToDoExistenceView.widthMargin
        ),
        self.toDoExistenceView.heightAnchor.constraint(
          equalToConstant: Constant.CalendarView.Layout.CollectionViewCell.ToDoExistenceView.heightMargin
        )
      ]
    )
  }
}
