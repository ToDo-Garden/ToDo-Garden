//
//  CalendarView.swift
//
//
//  Created by Wood on 5/31/24.
//

import UIKit

public final class CalendarView: UIView {
  private var model: Model

  private var monthLabel: UILabel
  private var backButton: UIButton

  public init(model: Model) {
    self.model = model
    self.monthLabel = UILabel()
    self.backButton = UIButton()
    super.init(frame: CGRect.zero)
    self.setup()
  }

  @available(*, deprecated)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Private Functions

extension CalendarView {
  private func setup() {
    self.setupUI()
  }
}

// MARK: Set up UI

extension CalendarView {
  private func setupUI() {
    self.setupMonthLabel()
    self.setupBackButton()
    self.addSubviews()
    self.setupSubviewsLayout()
  }

  private func setupMonthLabel() {
    self.monthLabel.font = UIFont.pretendardHeadBold
    self.monthLabel.textColor = UIColor.toDoGardenGreenDark
  }

  private func setupBackButton() {
    self.backButton.setImage(UIImage.backwardButtonImage, for: UIControl.State.normal)

    let action = UIAction { [weak self] _ in
      self?.calendarViewDelegate.scrollCalendar(to: CalendarScrollDirection.left, animated: true)
    }
    self.backButton.addAction(action, for: UIControl.Event.touchUpInside)
  }
}

// MARK: Auto Layout

extension CalendarView {
  private func addSubviews() {
    self.addSubview(self.monthLabel)
    self.addSubview(self.backButton)
  }

  private func setupSubviewsLayout() {
    self.setupMonthLabelLayout()
    self.setupBackButtonLayout()
  }

  private func setupMonthLabelLayout() {
    self.monthLabel.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.monthLabel.topAnchor.constraint(
          equalTo: self.topAnchor,
          constant: Constant.CalendarView.Layout.MonthLabel.topMargin
        ),
        self.monthLabel.leadingAnchor.constraint(
          equalTo: self.leadingAnchor,
          constant: Constant.CalendarView.Layout.MonthLabel.leadingMargin
        ),
        self.monthLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.backButton.leadingAnchor)
      ]
    )
  }

  private func setupBackButtonLayout() {
    self.backButton.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.backButton.trailingAnchor.constraint(
          equalTo: self.forwardButton.leadingAnchor,
          constant: -Constant.CalendarView.Layout.BackButton.trailingMargin
        ),
        self.backButton.centerYAnchor.constraint(equalTo: self.monthLabel.centerYAnchor),
        self.backButton.widthAnchor.constraint(
          equalToConstant: Constant.CalendarView.Layout.BackButton.widthMargin
        ),
        self.backButton.heightAnchor.constraint(
          equalToConstant: Constant.CalendarView.Layout.BackButton.heightMargin
        )
      ]
    )
  }
}

// MARK: Model

extension CalendarView {
  public struct Model {
    let borderWidth: CGFloat
    let cornerRadius: CGFloat
    let collectionView: Model.CollectionView

    public static let primary = Self(
      borderWidth: Constant.CalendarView.Layout.Primary.borderWidth,
      cornerRadius: Constant.CalendarView.Layout.Primary.cornerRadius,
      collectionView: CollectionView(
        itemSize: Constant.CalendarView.Layout.Primary.itemSize,
        itemSpacing: Constant.CalendarView.Layout.Primary.itemSpacing,
        lineSpacing: Constant.CalendarView.Layout.Primary.lineSpacing
      )
    )
  }
}

extension CalendarView.Model {
  public struct CollectionView {
    let itemSize: CGSize
    let itemSpacing: CGFloat
    let lineSpacing: CGFloat
  }
}
