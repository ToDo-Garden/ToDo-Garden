//
//  CalendarViewDelegate.swift
//
//
//  Created by Wood on 5/31/24.
//

import UIKit

import ToDoGardenUIConstant

final class CalendarViewDelegate: NSObject {
  private var calendarDataGenerator: CalendarDataGeneratable
  private var dateFormatter: DateFormatter

  private var collectionView: UICollectionView
  private var collectionViewDataSource: UICollectionViewDiffableDataSource<CalendarSection, CalendarItem>!
  private var currentIndexPath: IndexPath
  private var collectionViewModel: CalendarView.Model.CollectionView
  private var initialContentOffset: CGPoint
  private var selectedItem: CalendarItem?

  init(
    collectionView: UICollectionView,
    collectionViewModel: CalendarView.Model.CollectionView
  ) {
    self.calendarDataGenerator = CalendarDataGenerator(calendar: Calendar.localeUpdated)
    self.dateFormatter = DateFormatter()
    self.collectionView = collectionView
    self.currentIndexPath = IndexPath(item: 0, section: 3)
    self.initialContentOffset = CGPoint()
    super.init()
    self.setupDateFormatter()
    self.loadInitialMonthSnapshot()
  }

  func scrollCalendar(to scrollDirection: CalendarScrollDirection, animated: Bool) {
    self.currentIndexPath.section += scrollDirection.rawValue
    self.collectionView.scrollToItem(
      at: self.currentIndexPath,
      at: UICollectionView.ScrollPosition.left,
      animated: animated
    )
  }

  func getCollectionViewHeight() -> CGFloat {
    let snapshot = self.collectionViewDataSource.snapshot()
    let currentSection = snapshot.sectionIdentifiers[self.currentIndexPath.section]
    let itemCount = snapshot.itemIdentifiers(inSection: currentSection).count
    return self.calculateHeight(items: itemCount)
  }
}

extension CalendarViewDelegate {
  private func setupDateFormatter() {
    if let userPreferredIdentifier = Locale.preferredLanguages.first {
      let userLocale = Locale(identifier: userPreferredIdentifier)
      self.dateFormatter.locale = userLocale
    } else {
      self.dateFormatter.locale = Locale.autoupdatingCurrent
    }
    self.dateFormatter.dateFormat = Constant.CalendarView.StringLiteral.dateFormat
  }

  private func calculateHeight(items count: Int) -> CGFloat {
    let numberOfRows = CGFloat(count / 7)
    let totalItemHeight = self.collectionViewModel.itemSize.height * numberOfRows
    let totalInsets = self.collectionViewModel.lineSpacing * (numberOfRows - 1)
    let collectionViewHeight = totalItemHeight + totalInsets
    let defaultHeight: CGFloat = Constant.CalendarView.Layout.CollectionView.defaultHeight

    return defaultHeight + collectionViewHeight
  }
}

// MARK: Diffable DataSource

extension CalendarViewDelegate {
  private func setupCollectionViewDataSource() {
    self.collectionViewDataSource = self.makeDiffableDataSource(self.collectionView, with: self.dateFormatter)
    self.collectionView.dataSource = self.collectionViewDataSource
  }

  private func loadInitialMonthSnapshot() {
    var snapshot = self.collectionViewDataSource.snapshot()
    let currentDate = Date()
    let dateRange = (-3...3)
    dateRange.forEach { (addValue: Int) in
      guard let monthData = try? self.calendarDataGenerator.fetchMonthData(from: currentDate, add: addValue)
      else { return }

      let section = CalendarSection(firstDay: monthData.firstDayOfMonth)
      snapshot.appendSections([section])

      let newItems = monthData.dates.map { (day: MonthData.Day) in
        let date = day.date
        let isThisMonth = day.isThisMonth
        return CalendarItem(date: date, isThisMonth: isThisMonth)
      }
      snapshot.appendItems(newItems, toSection: section)
    }

    self.collectionViewDataSource.apply(snapshot)
  }

  private func reloadAllSnapshot() {
    let lastSection = self.collectionViewDataSource.snapshot().sectionIdentifiers.count - 1
    guard self.currentIndexPath.section <= 0 || self.currentIndexPath.section >= lastSection
    else { return }

    let currentSnapshot = self.collectionViewDataSource.snapshot()
    let scrollDirection: CalendarScrollDirection = self.currentIndexPath.section == 0 ? .left : .right
    let snapshot1 = self.deleteSections(by: scrollDirection, to: currentSnapshot)
    let snapshot2 = self.insertNewSection(by: scrollDirection, to: snapshot1)

    self.collectionViewDataSource?.apply(
      snapshot2,
      animatingDifferences: false
    ) {
      self.moveToCurrentMonth()
    }
  }

  private func deleteSections(
    by scrollDirection: CalendarScrollDirection,
    to snapshot: NSDiffableDataSourceSnapshot<CalendarSection, CalendarItem>
  ) -> NSDiffableDataSourceSnapshot<CalendarSection, CalendarItem> {
    var newSnapshot = snapshot

    for _ in (0...2) {
      let sections = newSnapshot.sectionIdentifiers
      let sectionToDelete = scrollDirection == CalendarScrollDirection.left ? sections.last : sections.first
      if let section = sectionToDelete {
        let itemsToDelete = newSnapshot.itemIdentifiers(inSection: section)
        newSnapshot.deleteItems(itemsToDelete)
        newSnapshot.deleteSections([section])
      }
    }

    return newSnapshot
  }

  private func insertNewSection(
    by scrollDirection: CalendarScrollDirection,
    to snapshot: NSDiffableDataSourceSnapshot<CalendarSection, CalendarItem>
  ) -> NSDiffableDataSourceSnapshot<CalendarSection, CalendarItem> {
    var newSnapshot = snapshot

    for _ in (0...2) {
      let sections = newSnapshot.sectionIdentifiers
      let section = scrollDirection == .left ? sections.first : sections.last
      let addValue = scrollDirection == .left ? -1 : 1
      if let section2 = section {
        guard let monthData = try? self.calendarDataGenerator.fetchMonthData(from: section2.firstDay, add: addValue)
        else { continue }

        let sectionToAppend = CalendarSection(firstDay: monthData.firstDayOfMonth)
        if scrollDirection == CalendarScrollDirection.left {
          newSnapshot.insertSections([sectionToAppend], beforeSection: section2)
        } else {
          newSnapshot.appendSections([sectionToAppend])
        }

        let newItems = monthData.dates.map { (day: MonthData.Day) in
          let date = day.date
          let isThisMonth = day.isThisMonth
          return CalendarItem(date: date, isThisMonth: isThisMonth)
        }
        newSnapshot.appendItems(newItems, toSection: sectionToAppend)
      }
    }

    return newSnapshot
  }

  private func moveToCurrentMonth() {
    let currentMonthOffset = CGPoint(
      x: self.collectionView.frame.width * 3,
      y: self.collectionView.bounds.origin.y
    )
    self.collectionView.setContentOffset(currentMonthOffset, animated: false)
  }
}

// MARK: UIScrollView Deleagate Functions

extension CalendarViewDelegate: UICollectionViewDelegate {
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    self.initialContentOffset = scrollView.contentOffset
  }

  func scrollViewWillEndDragging(
    _ scrollView: UIScrollView,
    withVelocity velocity: CGPoint,
    targetContentOffset: UnsafeMutablePointer<CGPoint>
  ) {
    let contentOffset = scrollView.contentOffset.x
    let targetContentOffset = targetContentOffset.pointee.x
    let velocity = velocity.x
    let scrollViewWidth = scrollView.frame.width

    guard let scrollDirection = self.calculateScrollDireciton(
      contentOffset,
      targetContentOffset,
      velocity,
      scrollViewWidth / 2
    ) else { return }

    self.currentIndexPath.section += scrollDirection.rawValue
  }

  private func calculateScrollDireciton(
    _ contentOffset: CGFloat,
    _ targetContentOffset: CGFloat,
    _ velocity: CGFloat,
    _ scrollViewHalfWidth: CGFloat
  ) -> CalendarScrollDirection? {
    guard velocity == 0 else {
      return velocity > 0 ? CalendarScrollDirection.right : CalendarScrollDirection.left
    }

    let hasScrolledFarEnough = abs(contentOffset - self.initialContentOffset.x) > scrollViewHalfWidth
    guard hasScrolledFarEnough else {
      return nil
    }

    return contentOffset > targetContentOffset ?
    CalendarScrollDirection.left : CalendarScrollDirection.right
  }

  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    self.reloadAllSnapshot()
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    self.reloadAllSnapshot()
  }
}

// MARK: Cell Selection Functions

extension CalendarViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let selectedNewItem = self.collectionViewDataSource.itemIdentifier(for: indexPath)
    else { return }

    let comparisonResult = self.validateIsSameMonth(selectedItem: selectedNewItem, section: indexPath)
    guard comparisonResult != ComparisonResult.orderedSame
    else {
      self.selectedItem = selectedNewItem
      return
    }

    let scrollDirection = comparisonResult == ComparisonResult.orderedAscending ?
    CalendarScrollDirection.left : CalendarScrollDirection.right
    self.scrollCalendar(to: scrollDirection, animated: true)
    self.setSelected(to: selectedNewItem)
    self.selectedItem = selectedNewItem
  }

  private func validateIsSameMonth(selectedItem: CalendarItem, section indexPath: IndexPath) -> ComparisonResult {
    guard let date = self.collectionViewDataSource.sectionIdentifier(for: indexPath.section)?.firstDay
    else { return ComparisonResult.orderedSame }

    return self.calendarDataGenerator.compareMonth(
      date1: selectedItem.date,
      with: date
    )
  }

  private func setSelected(to item: CalendarItem) {
    let snapshot = self.collectionViewDataSource.snapshot()
    let section = snapshot.sectionIdentifiers[self.currentIndexPath.section]
    let indexOfItem = snapshot.itemIdentifiers(inSection: section).firstIndex { (calendarItem: CalendarItem) in
      return item.date == calendarItem.date
    }

    if let itemIndex = indexOfItem {
      let itemIndexPath = IndexPath(item: itemIndex, section: self.currentIndexPath.section)
      self.collectionView.selectItem(
        at: itemIndexPath,
        animated: true,
        scrollPosition: []
      )
    }
  }
}

enum CalendarScrollDirection: Int {
  case left  = -1
  case current = 0
  case right = 1
}
