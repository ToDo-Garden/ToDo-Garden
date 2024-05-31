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
  private var dayLabel: UILabel

  override var isSelected: Bool {
    willSet {
      if newValue {
        self.selected()
      } else {
        self.deSelected()
      }
    }
  }

  override init(frame: CGRect) {
    self.toDoExistenceView = UIView()
    self.dayLabel = UILabel()
    super.init(frame: CGRect.zero)
    self.setup()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    self.deSelected()
  }

  func update(dayString: String, isThisMonth: Bool) {
    self.dayLabel.text = dayString
    if isThisMonth == false {
      self.dayLabel.textColor = UIColor.toDoGardenGreenGray
    }
  }
}

// MARK: Private Functions

extension CalendarCollectionViewCell {
  private func selected() {
    self.backgroundColor = UIColor.toDoGardenGreenDark
    self.dayLabel.textColor = UIColor.toDoGardenWhite
  }

  private func deSelected() {
    self.backgroundColor = UIColor.toDoGardenWhite
    self.dayLabel.textColor = UIColor.toDoGardenGreenDark
  }

  private func setup() {
    self.setupLayer()
    self.setupToDoExistenceView()
    self.setupDayLabel()
    self.addSubviews()
    self.setupSubviewsLayout()
  }

  private func setupLayer() {
    self.layer.cornerRadius = Constant.CalendarView.Layout.CollectionViewCell.cornerRadius
  }

  private func setupDayLabel() {
    self.dayLabel.font = UIFont.pretendardBodySemiBold
    self.dayLabel.textColor = UIColor.toDoGardenGreenDark
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
    self.addSubview(self.dayLabel)
  }

  private func setupSubviewsLayout() {
    self.setupToDoExistenceViewLayout()
    self.setupDayLabelLayout()
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

  private func setupDayLabelLayout() {
    self.dayLabel.usingAutolayout()

    NSLayoutConstraint.activate([
      self.dayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      self.dayLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    ])
  }
}

// MARK: Cell Identifier

extension CalendarCollectionViewCell: ReusableIdentifier {
  static var identifier = Constant.CalendarView.StringLiteral.cellIdentifier
}
