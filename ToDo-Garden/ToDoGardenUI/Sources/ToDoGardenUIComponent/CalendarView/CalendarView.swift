//
//  CalendarView.swift
//
//
//  Created by Wood on 5/31/24.
//

import UIKit

import ToDoGardenUIConstant

public final class CalendarView: UIView {
  private let model: Model
  private let calendarViewDelegate: CalendarViewControllable
  private var isLayoutSubviewsCalled: Bool

  private let monthLabel: UILabel
  private let backButton: UIButton
  private let forwardButton: UIButton
  private let weekdaySymbolStackView: UIStackView
  private let collectionView: UICollectionView
  private var heightConstraint: NSLayoutConstraint

  public init(model: Model) {
    self.model = model
    self.isLayoutSubviewsCalled = false
    self.monthLabel = UILabel()
    self.backButton = UIButton()
    self.forwardButton = UIButton()
    self.weekdaySymbolStackView = UIStackView()
    self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
    self.heightConstraint = NSLayoutConstraint()
    self.calendarViewDelegate = CalendarViewSingleSelectionDelegate(collectionView: self.collectionView)
    super.init(frame: CGRect.zero)
    self.setup()
  }

  @available(*, deprecated)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    self.scrollToCurrentMonth()
  }
}

// MARK: Private Functions

extension CalendarView {
  private func setup() {
    self.setupUI()
  }

  private func scrollToCurrentMonth() {
    if self.isLayoutSubviewsCalled == false {
      self.calendarViewDelegate.scrollCalendar(
        to: CalendarScrollDirection.current,
        animated: false
      )
      self.isLayoutSubviewsCalled = true
    }
  }
}

// MARK: ScrollDirection Sender Delegate

protocol CalendarScrollSendable {
  func didScrolled()
}

extension CalendarView: CalendarScrollSendable {
  func didScrolled() {
    self.updateMonthLabelText()
  }

  private func updateMonthLabelText() {
    let text = self.calendarViewDelegate.getDateString()
    self.monthLabel.text = text
  }
}

// MARK: Set up UI

extension CalendarView {
  private func setupUI() {
    self.setupBorder()
    self.setupMonthLabel()
    self.setupBackButton()
    self.setupForwardButton()
    self.setupWeekdaySymbolStackView()
    self.setupCollectionView()
    self.addSubviews()
    self.setupSubviewsLayout()
  }

  private func setupBorder() {
    self.layer.cornerRadius = self.model.cornerRadius
    self.layer.borderWidth = self.model.borderWidth
    self.layer.borderColor = UIColor.toDoGardenGreenGray.cgColor
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

  private func setupCollectionView() {
    self.configureCollectionView(self.collectionView)
    self.collectionView.collectionViewLayout = self.makeCollectionViewLayout(with: self.model.collectionView)
  }
}

// MARK: Auto Layout

extension CalendarView {
  private func addSubviews() {
    self.addSubview(self.monthLabel)
    self.addSubview(self.backButton)
    self.addSubview(self.forwardButton)
    self.addSubview(self.weekdaySymbolStackView)
    self.addSubview(self.collectionView)
  }

  private func setupSubviewsLayout() {
    self.setupMonthLabelLayout()
    self.setupBackButtonLayout()
    self.setupForwardButtonLayout()
    self.setupWeekdaySymbolStackViewLayout()
    self.setupCollectionViewLayout()
    self.setupHeightConstraint()
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
      constant: Constant.CalendarView.Layout.WeekdaySymbolStackView.topMargin
    )
    topConstraint.priority = UILayoutPriority.defaultLow
    topConstraint.isActive = true

    NSLayoutConstraint.activate(
      [
        self.weekdaySymbolStackView.leadingAnchor.constraint(
          equalTo: self.leadingAnchor,
          constant: Constant.CalendarView.Layout.WeekdaySymbolStackView.leadingMargin
        ),
        self.weekdaySymbolStackView.trailingAnchor.constraint(
          equalTo: self.trailingAnchor,
          constant: -Constant.CalendarView.Layout.WeekdaySymbolStackView.trailingMargin
        )
      ]
    )
  }

  private func setupCollectionViewLayout() {
    self.collectionView.usingAutolayout()

    NSLayoutConstraint.activate(
      [
        self.collectionView.topAnchor.constraint(
          equalTo: self.weekdaySymbolStackView.bottomAnchor,
          constant: Constant.CalendarView.Layout.CollectionView.topMargin
        ),
        self.collectionView.leadingAnchor.constraint(
          equalTo: self.leadingAnchor,
          constant: Constant.CalendarView.Layout.CollectionView.leadingMargin
        ),
        self.collectionView.trailingAnchor.constraint(
          equalTo: self.trailingAnchor,
          constant: -Constant.CalendarView.Layout.CollectionView.trailingMargin
        ),
        self.collectionView.bottomAnchor.constraint(
          equalTo: self.bottomAnchor,
          constant: -Constant.CalendarView.Layout.CollectionView.bottomMargin
        )
      ]
    )
  }

  private func setupHeightConstraint() {
    self.heightConstraint = self.heightAnchor.constraint(equalToConstant: 0)
    self.heightConstraint.isActive = true
  }
}

// MARK: Model

extension CalendarView {
  public struct Model {
    let borderWidth: CGFloat
    let cornerRadius: CGFloat
    let collectionView: Model.CollectionView

    public static let primary = Self(
      borderWidth: Constant.CalendarView.Model.Primary.borderWidth,
      cornerRadius: Constant.CalendarView.Model.Primary.cornerRadius,
      collectionView: CollectionView(
        itemSize: Constant.CalendarView.Model.Primary.itemSize,
        itemSpacing: Constant.CalendarView.Model.Primary.itemSpacing,
        lineSpacing: Constant.CalendarView.Model.Primary.lineSpacing
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

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let calendarView = CalendarView(model: .primary)
  calendarView.widthAnchor.constraint(equalToConstant: 323).isActive = true
  return calendarView
}
#endif
