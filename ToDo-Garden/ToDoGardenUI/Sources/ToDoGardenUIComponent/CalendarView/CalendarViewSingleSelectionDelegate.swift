//
//  CalendarViewDelegate.swift
//
//
//  Created by Wood on 5/31/24.
//

import UIKit

import ToDoGardenUIConstant

protocol CalendarViewControllable where Self: NSObject {
  func fetchWeekdaySymbols() -> [String]
  func scrollCalendar(to scrollDirection: CalendarScrollDirection, animated: Bool)
  func getDateString() -> String
}

class CalendarViewSingleSelectionDelegate: NSObject {
  private var calendarDataGenerator: CalendarDataGeneratable
  private var dateFormatter: DateFormatter

  private var collectionView: UICollectionView
  private var collectionViewDataSource: UICollectionViewDiffableDataSource<CalendarSection, CalendarItem>!
  private var currentIndexPath: IndexPath
  private var initialContentOffset: CGPoint
  private var selectedItem: CalendarItem?

  init(collectionView: UICollectionView) {
    self.calendarDataGenerator = CalendarDataGenerator(calendar: Calendar.localeUpdated)
    self.dateFormatter = DateFormatter()
    self.collectionView = collectionView
    self.currentIndexPath = IndexPath(item: 0, section: 3)
    self.initialContentOffset = CGPoint()
    super.init()
    self.setupDateFormatter()
    self.setupCollectionViewDataSource()
    self.loadInitialMonthSnapshot()
  }
}

// MARK: CalendarViewControllable Protocol

extension CalendarViewSingleSelectionDelegate: CalendarViewControllable {
  func fetchWeekdaySymbols() -> [String] {
    return self.calendarDataGenerator.fetchWeekdaySymbols()
  }

  func scrollCalendar(to scrollDirection: CalendarScrollDirection, animated: Bool) {
    self.currentIndexPath.section += scrollDirection.rawValue
    self.collectionView.scrollToItem(
      at: self.currentIndexPath,
      at: UICollectionView.ScrollPosition.left,
      animated: animated
    )
    self.reloadAllSnapshot()
  }

  func getDateString() -> String {
    let snapShot = self.collectionViewDataSource.snapshot()
    let currentSectionDate = snapShot.sectionIdentifiers[self.currentIndexPath.section].firstDay
    let formattedString = self.dateFormatter.string(from: currentSectionDate).split(separator: " ")
    let dateString = formattedString[0] + " \(formattedString[1])"
    return String(dateString)
  }
}

// MARK: Private Functions

extension CalendarViewSingleSelectionDelegate {
  private func setupDateFormatter() {
    if let userPreferredIdentifier = Locale.preferredLanguages.first {
      let userLocale = Locale(identifier: userPreferredIdentifier)
      self.dateFormatter.locale = userLocale
    } else {
      self.dateFormatter.locale = Locale.autoupdatingCurrent
    }
  }
}

// MARK: Diffable DataSource

extension CalendarViewSingleSelectionDelegate {
  private func setupCollectionViewDataSource() {
    self.collectionViewDataSource = self.makeDiffableDataSource(self.collectionView, with: self.dateFormatter)
    self.collectionView.dataSource = self.collectionViewDataSource
  }

  private func loadInitialMonthSnapshot() {
    let snapshot = self.collectionViewDataSource.snapshot()
    let dateRange = (-3...3)
    guard let newSnapshot = try? self.addMonthData(to: snapshot, with: dateRange, isAppendFirst: false)
    else { return }

    self.collectionViewDataSource.apply(newSnapshot)
  }

  private func reloadAllSnapshot() {
    let lastSection = self.collectionViewDataSource.snapshot().sectionIdentifiers.count - 1
    guard self.currentIndexPath.section <= 0 || self.currentIndexPath.section >= lastSection
    else { return }

    guard let deletedSnapshot = try? self.deleteSections(to: self.collectionViewDataSource.snapshot()),
    let updatedSnapshot = try? self.insertNewSection(to: deletedSnapshot)
    else { return }

    self.currentIndexPath.section = 3

    self.collectionViewDataSource.apply(
      updatedSnapshot,
      animatingDifferences: false
    ) {
      self.moveToCurrentMonth()
    }
  }

  private func deleteSections(
    to snapshot: NSDiffableDataSourceSnapshot<CalendarSection, CalendarItem>
  ) throws -> NSDiffableDataSourceSnapshot<CalendarSection, CalendarItem> {
    var newSnapshot = snapshot

    for _ in (0...2) {
      let sections = newSnapshot.sectionIdentifiers
      guard let sectionToDelete = self.currentIndexPath.section == 0 ? sections.last : sections.first
      else { throw CalendarViewDelegateError.snapshotIsNotLoaded }

      let itemsToDelete = newSnapshot.itemIdentifiers(inSection: sectionToDelete)
      newSnapshot.deleteItems(itemsToDelete)
      newSnapshot.deleteSections([sectionToDelete])
    }

    return newSnapshot
  }

  private func insertNewSection(
    to snapshot: NSDiffableDataSourceSnapshot<CalendarSection, CalendarItem>
  ) throws -> NSDiffableDataSourceSnapshot<CalendarSection, CalendarItem> {
    let isAppendFirst = self.currentIndexPath.section == 0 ? true : false
    return try self.addMonthData(
      to: snapshot,
      with: (1...3),
      isAppendFirst: isAppendFirst
    )
  }

  private func addMonthData(
    to snapshot: NSDiffableDataSourceSnapshot<CalendarSection, CalendarItem>,
    with dateRange: ClosedRange<Int>,
    isAppendFirst: Bool
  ) throws -> NSDiffableDataSourceSnapshot<CalendarSection, CalendarItem> {
    var newSnapshot = snapshot
    let sections = newSnapshot.sectionIdentifiers
    guard let firstDay = isAppendFirst ? sections.first?.firstDay : sections.last?.firstDay ?? Date()
    else { throw CalendarViewDelegateError.snapshotIsNotLoaded }

    for value in dateRange {
      let addValue = self.currentIndexPath.section == 0 ? -value : value
      let monthData = try self.calendarDataGenerator.fetchMonthData(from: firstDay, add: addValue)

      let section = CalendarSection(firstDay: monthData.firstDayOfMonth)
      if isAppendFirst {
        guard let beforeSection = newSnapshot.sectionIdentifiers.first
        else { throw CalendarViewDelegateError.snapshotIsNotLoaded }

        newSnapshot.insertSections([section], beforeSection: beforeSection)
      } else {
        newSnapshot.appendSections([section])
      }

      let items = monthData.dates.map { (day: MonthData.Day) in
        let date = day.date
        let isThisMonth = day.isThisMonth
        return CalendarItem(date: date, isThisMonth: isThisMonth)
      }
      newSnapshot.appendItems(items, toSection: section)
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

extension CalendarViewSingleSelectionDelegate: UICollectionViewDelegate {
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

extension CalendarViewSingleSelectionDelegate {
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

    return self.calendarDataGenerator.compareMonth(from: selectedItem.date, with: date)
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

enum CalendarViewDelegateError: Error {
  case snapshotIsNotLoaded
}
