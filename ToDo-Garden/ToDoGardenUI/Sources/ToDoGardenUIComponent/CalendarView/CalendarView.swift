//
//  CalendarView.swift
//
//
//  Created by Wood on 5/31/24.
//

import UIKit

public final class CalendarView: UIView {
  private var model: Model
  private var calendarViewDelegate: CalendarViewDelegate

  private var monthLabel: UILabel
  private var backButton: UIButton
  private var forwardButton: UIButton
  private var weekdaySymbolStackView: UIStackView

  public init(model: Model) {
    self.model = model
    self.calendarViewDelegate = CalendarViewDelegate()
    self.monthLabel = UILabel()
    self.backButton = UIButton()
    self.forwardButton = UIButton()
    self.weekdaySymbolStackView = UIStackView()
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
    self.setupForwardButton()
    self.setupWeekdaySymbolStackView()
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

  private func setupForwardButton() {
    self.forwardButton.setImage(UIImage.forwardButtonImage, for: UIControl.State.normal)

    let action = UIAction { [weak self] _ in
      self?.calendarViewDelegate.scrollCalendar(to: CalendarScrollDirection.right, animated: true)
    }
    self.forwardButton.addAction(action, for: UIControl.Event.touchUpInside)
  }

  private func setupWeekdaySymbolStackView() {
    self.weekdaySymbolStackView.distribution = UIStackView.Distribution.equalSpacing
    let symbols = self.calendarViewDelegate.fetchWeekdaySymbols()
    symbols.forEach { (symbol: String) in
      let daySymbolLabel = UILabel()
      daySymbolLabel.text = symbol
      daySymbolLabel.textColor = UIColor.toDoGardenGray3
      daySymbolLabel.font = UIFont.pretendardBodySemiBold
      self.weekdaySymbolStackView.addArrangedSubview(daySymbolLabel)
    }
  }
}

// MARK: Auto Layout

extension CalendarView {
  private func addSubviews() {
    self.addSubview(self.monthLabel)
    self.addSubview(self.backButton)
    self.addSubview(self.forwardButton)
    self.addSubview(self.weekdaySymbolStackView)
  }

  private func setupSubviewsLayout() {
    self.setupMonthLabelLayout()
    self.setupBackButtonLayout()
    self.setupForwardButtonLayout()
    self.setupWeekdaySymbolStackViewLayout()
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

  private func setupForwardButtonLayout() {
    self.forwardButton.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.forwardButton.centerYAnchor.constraint(equalTo: self.monthLabel.centerYAnchor),
        self.forwardButton.trailingAnchor.constraint(
          equalTo: self.trailingAnchor,
          constant: -Constant.CalendarView.Layout.ForwardButton.trailingMargin
        ),
        self.forwardButton.widthAnchor.constraint(
          equalToConstant: Constant.CalendarView.Layout.ForwardButton.widthMargin
        ),
        self.forwardButton.heightAnchor.constraint(
          equalToConstant: Constant.CalendarView.Layout.ForwardButton.heightMargin
        )
      ]
    )
  }

  private func setupWeekdaySymbolStackViewLayout() {
    self.weekdaySymbolStackView.usingAutolayout()

    let topConstraint = self.weekdaySymbolStackView.topAnchor.constraint(
      equalTo: self.monthLabel.bottomAnchor,
      constant: Constant.CalendarView.Layout.StackView.topMargin
    )
    topConstraint.priority = UILayoutPriority.defaultLow
    topConstraint.isActive = true

    NSLayoutConstraint.activate(
      [
        self.weekdaySymbolStackView.leadingAnchor.constraint(
          equalTo: self.leadingAnchor,
          constant: Constant.CalendarView.Layout.StackView.leadingMargin
        ),
        self.weekdaySymbolStackView.trailingAnchor.constraint(
          equalTo: self.trailingAnchor,
          constant: -Constant.CalendarView.Layout.StackView.trailingMargin
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
