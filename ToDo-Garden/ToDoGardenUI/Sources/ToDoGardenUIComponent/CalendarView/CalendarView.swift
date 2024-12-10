//
//  CalendarView.swift
//
//
//  Created by Wood on 5/31/24.
//

import UIKit

import ToDoGardenUIConstant

public protocol CalendarViewDateSelectionDelegate: AnyObject {
  func didSelectDate(_ date: Date)
}

public class CalendarView: UIView {
  private let model: Model
  private var isLayoutSubviewsCalled: Bool
  private let monthLabel: UILabel
  private let leftScrollButton: UIButton
  private let rightScrollButton: UIButton
  private let weekdaySymbolStackView: UIStackView
  private var heightConstraint: NSLayoutConstraint
  
  let dateCollectionView: UICollectionView
  var calendarViewDelegate: CalendarViewDelegate

  public weak var dateSelectionDelegate: CalendarViewDateSelectionDelegate?

  public init(model: Model) {
    self.model = model
    self.isLayoutSubviewsCalled = false
    self.monthLabel = UILabel()
    self.leftScrollButton = UIButton()
    self.rightScrollButton = UIButton()
    self.weekdaySymbolStackView = UIStackView()
    self.dateCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
    self.heightConstraint = NSLayoutConstraint()
    self.calendarViewDelegate = CalendarViewSingleSelectionDelegate(
      collectionView: self.dateCollectionView,
      collectionViewLayoutModel: model.collectionViewLayout,
      cellIdentifier: CalendarCollectionViewCell.identifier
    )
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
  private func scrollToCurrentMonth() {
    if self.isLayoutSubviewsCalled == false {
      self.calendarViewDelegate.scrollCalendar(
        to: CalendarScrollDirection.current,
        animated: false
      )
      self.isLayoutSubviewsCalled = true
    }
  }
  
  private func setup() {
    self.setupUI()
    self.setupCollectionViewScrollDelegate()
  }
  
  func setupCollectionViewScrollDelegate() {
    self.calendarViewDelegate.scrollDelegate = self
  }
}

// MARK: ScrollDirection Sender Delegate

protocol CalendarScrollSendable: AnyObject {
  func didScroll()
}

extension CalendarView: CalendarScrollSendable {
  func didScroll() {
    self.updateCollectionViewHeight()
    self.updateMonthLabelText()
  }

  private func updateCollectionViewHeight() {
    self.superview?.layoutIfNeeded()
    let duration = Constant.CalendarView.Animation.duration
    UIView.animate(withDuration: duration) {
      let collectionViewHeight = self.calendarViewDelegate.getCollectionViewHeight()
      self.heightConstraint.constant = collectionViewHeight
      self.superview?.layoutIfNeeded()
    }
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
    self.setupDateCollectionView()
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
    self.leftScrollButton.setImage(UIImage.backwardButtonImage, for: UIControl.State.normal)
    
    let action = UIAction { [weak self] _ in
      self?.calendarViewDelegate.scrollCalendar(to: CalendarScrollDirection.left, animated: true)
    }
    self.leftScrollButton.addAction(action, for: UIControl.Event.touchUpInside)
  }

  private func setupForwardButton() {
    self.rightScrollButton.setImage(UIImage.forwardButtonImage, for: UIControl.State.normal)
    
    let action = UIAction { [weak self] _ in
      self?.calendarViewDelegate.scrollCalendar(to: CalendarScrollDirection.right, animated: true)
    }
    self.rightScrollButton.addAction(action, for: UIControl.Event.touchUpInside)
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

  private func setupDateCollectionView() {
    self.configureCollectionView(self.dateCollectionView)
    self.dateCollectionView.collectionViewLayout = self.makeCollectionViewLayout(with: self.model.collectionViewLayout)
    self.dateCollectionView.delegate = self.calendarViewDelegate
  }
}

// MARK: Auto Layout

extension CalendarView {
  private func addSubviews() {
    self.addSubview(self.monthLabel)
    self.addSubview(self.leftScrollButton)
    self.addSubview(self.rightScrollButton)
    self.addSubview(self.weekdaySymbolStackView)
    self.addSubview(self.dateCollectionView)
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
        self.monthLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.leftScrollButton.leadingAnchor)
      ]
    )
  }

  private func setupBackButtonLayout() {
    self.leftScrollButton.usingAutolayout()
    
    NSLayoutConstraint.activate(
      [
        self.leftScrollButton.trailingAnchor.constraint(
          equalTo: self.rightScrollButton.leadingAnchor,
          constant: -Constant.CalendarView.Layout.BackButton.trailingMargin
        ),
        self.leftScrollButton.centerYAnchor.constraint(equalTo: self.monthLabel.centerYAnchor),
        self.leftScrollButton.widthAnchor.constraint(
          equalToConstant: Constant.CalendarView.Layout.BackButton.widthMargin
        ),
        self.leftScrollButton.heightAnchor.constraint(
          equalToConstant: Constant.CalendarView.Layout.BackButton.heightMargin
        )
      ]
    )
  }

  private func setupForwardButtonLayout() {
    self.rightScrollButton.usingAutolayout()
    
    NSLayoutConstraint.activate(
      [
        self.rightScrollButton.centerYAnchor.constraint(equalTo: self.monthLabel.centerYAnchor),
        self.rightScrollButton.trailingAnchor.constraint(
          equalTo: self.trailingAnchor,
          constant: -Constant.CalendarView.Layout.ForwardButton.trailingMargin
        ),
        self.rightScrollButton.widthAnchor.constraint(
          equalToConstant: Constant.CalendarView.Layout.ForwardButton.widthMargin
        ),
        self.rightScrollButton.heightAnchor.constraint(
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
    self.dateCollectionView.usingAutolayout()
    
    NSLayoutConstraint.activate(
      [
        self.dateCollectionView.topAnchor.constraint(
          equalTo: self.weekdaySymbolStackView.bottomAnchor,
          constant: Constant.CalendarView.Layout.CollectionView.topMargin
        ),
        self.dateCollectionView.leadingAnchor.constraint(
          equalTo: self.leadingAnchor,
          constant: Constant.CalendarView.Layout.CollectionView.leadingMargin
        ),
        self.dateCollectionView.trailingAnchor.constraint(
          equalTo: self.trailingAnchor,
          constant: -Constant.CalendarView.Layout.CollectionView.trailingMargin
        ),
        self.dateCollectionView.bottomAnchor.constraint(
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
    let collectionViewLayout: Model.CollectionViewLayout
    
    public static let primary = Self(
      borderWidth: Constant.CalendarView.Model.Primary.borderWidth,
      cornerRadius: Constant.CalendarView.Model.Primary.cornerRadius,
      collectionViewLayout: CollectionViewLayout(
        itemSize: Constant.CalendarView.Model.Primary.itemSize,
        itemSpacing: Constant.CalendarView.Model.Primary.itemSpacing,
        lineSpacing: Constant.CalendarView.Model.Primary.lineSpacing
      )
    )
  }
}

extension CalendarView.Model {
  public struct CollectionViewLayout {
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
