//
//  CalendarViewDelegate.swift
//
//
//  Created by Wood on 5/31/24.
//

import UIKit

import ToDoGardenUIConstant

protocol CalendarViewManager: UICollectionViewDelegate {
  var scrollDelegate: CalendarScrollSendable? { get set }
  var dateSelectionClosure: ((Date) -> Void)? { get set }

  func fetchWeekdaySymbols() -> [String]
  func getCollectionViewHeight() -> CGFloat
  @MainActor func scrollCalendar(to scrollDirection: CalendarScrollDirection, animated: Bool) async
  func getDateString() -> String
}

class CalendarViewSingleSelectionDelegate: NSObject {
  private let cellIdentifier: String
  private let calendarDataGenerator: CalendarDataGeneratable
  private let collectionViewLayoutModel: CalendarView.Model.CollectionViewLayout
  
  private(set) var collectionViewDataSource: UICollectionViewDiffableDataSource<CalendarSection, CalendarItem>!
  private(set) var currentIndexPath: IndexPath
  private(set) var selectedItem: CalendarItem?
  private var initialContentOffset: CGPoint
  
  let collectionView: UICollectionView
  let dateFormatter: DateFormatter
  
  weak var scrollDelegate: CalendarScrollSendable?
  var dateSelectionClosure: ((Date) -> Void)?

  init(
    collectionView: UICollectionView,
    collectionViewLayoutModel: CalendarView.Model.CollectionViewLayout,
    cellIdentifier: String
  ) {
    self.calendarDataGenerator = CalendarDataGenerator(calendar: Calendar.localeUpdated)
    self.dateFormatter = DateFormatter()
    self.collectionViewLayoutModel = collectionViewLayoutModel
    self.collectionView = collectionView
    self.currentIndexPath = IndexPath(item: 0, section: 3)
    self.initialContentOffset = CGPoint()
    self.cellIdentifier = cellIdentifier
    super.init()
    self.setupDateFormatter()
    self.setupCollectionViewDataSource()
    self.loadInitialMonthSnapshot()
  }
}

// MARK: CalendarViewControllable Protocol

extension CalendarViewSingleSelectionDelegate: CalendarViewManager {
  func fetchWeekdaySymbols() -> [String] {
    return self.calendarDataGenerator.fetchWeekdaySymbols()
  }
  
  func scrollCalendar(to scrollDirection: CalendarScrollDirection, animated: Bool) async {
    if self.currentIndexPath.section == 0 || self.currentIndexPath.section == 6 {
      await self.reloadAllSnapshot()
      }
      self.currentIndexPath.section += scrollDirection.rawValue
      self.scrollToItem(animated: animated)
      self.scrollDelegate?.didScroll()
  }

  func getCollectionViewHeight() -> CGFloat {
    let snapshot = self.collectionViewDataSource.snapshot()
    let currentSection = snapshot.sectionIdentifiers[self.currentIndexPath.section]
    let itemCount = snapshot.itemIdentifiers(inSection: currentSection).count
    return self.calculateHeight(items: itemCount)
  }

  func getDateString() -> String {
    let snapShot = self.collectionViewDataSource.snapshot()
    let currentSectionDate = snapShot.sectionIdentifiers[self.currentIndexPath.section].firstDay
    let formattedString = self.dateFormatter.string(from: currentSectionDate).split(separator: " ")
    let dateString = formattedString[0] + " \(formattedString[1])"
    return String(dateString)
  }

  func getSelectedItem() -> CalendarItem? {
    return self.selectedItem
  }
}

// MARK: Private Functions

extension CalendarViewSingleSelectionDelegate {
  private func scrollToItem(animated: Bool) {
    self.collectionView.scrollToItem(
      at: self.currentIndexPath,
      at: UICollectionView.ScrollPosition.left,
      animated: animated
    )
  }
  
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
    let totalItemHeight = self.collectionViewLayoutModel.itemSize.height * numberOfRows
    let totalInsets = self.collectionViewLayoutModel.lineSpacing * (numberOfRows - 1)
    let collectionViewHeight = totalItemHeight + totalInsets
    let defaultHeight: CGFloat = Constant.CalendarView.Layout.CollectionView.defaultHeight
    
    return defaultHeight + collectionViewHeight
  }
}

// MARK: Diffable DataSource

extension CalendarViewSingleSelectionDelegate {
  func setupCollectionViewDataSource() {
    self.collectionViewDataSource = self.makeDiffableDataSource(identifier: self.cellIdentifier)
    self.collectionView.dataSource = self.collectionViewDataSource
  }

  private func loadInitialMonthSnapshot() {
    let snapshot = self.collectionViewDataSource.snapshot()
    let dateRange = (-3...3)
    guard let newSnapshot = try? self.addMonthData(to: snapshot, with: dateRange, isAppendFirst: false)
    else { return }

    self.collectionViewDataSource.apply(newSnapshot)
  }
  
  private func reloadAllSnapshot() async {
    let snapshot = await self.collectionViewDataSource.snapshot()
    let lastSection = snapshot.sectionIdentifiers.count - 1
    guard self.currentIndexPath.section <= 0 || self.currentIndexPath.section >= lastSection else {
      return
    }
    
    let newSectionIndex = 3
    guard let deletedSnapshot = try? self.deleteSections(to: snapshot),
      let updatedSnapshot = try? self.insertNewSection(to: deletedSnapshot) else {
      return
    }
    
    await self.collectionViewDataSource.apply(
      updatedSnapshot,
      animatingDifferences: false,
      completion: {
      self.currentIndexPath.section = newSectionIndex
      self.moveToCurrentMonth()
      }
    )
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
    self.scrollDelegate?.didScroll()
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
    Task {
      await self.reloadAllSnapshot()
    }
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    Task {
      await self.reloadAllSnapshot()
    }
  }
}

// MARK: Cell Selection Functions

extension CalendarViewSingleSelectionDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let selectedNewItem = self.collectionViewDataSource.itemIdentifier(for: indexPath)
    else { return }

    if self.selectedItem != selectedNewItem {
      self.dateSelectionClosure?(selectedNewItem.date)
    }

    guard let scrollDirection = getScrollDirection(selectedItem: selectedNewItem, section: indexPath)
    else { return }
    
    Task { @MainActor in
      await self.scrollCalendar(to: scrollDirection, animated: true)
      self.selectedItem = selectedNewItem
    }
  }

  private func getScrollDirection(
    selectedItem: CalendarItem,
    section indexPath: IndexPath
  ) -> CalendarScrollDirection? {
    guard let currentDate = self.collectionViewDataSource.sectionIdentifier(for: indexPath.section)?.firstDay
    else { return nil }
    
    let comparisonResult = self.calendarDataGenerator.compareMonth(from: selectedItem.date, with: currentDate)
    guard comparisonResult != ComparisonResult.orderedSame
    else {
      self.selectedItem = selectedItem
      return nil
    }
    
    return comparisonResult == ComparisonResult.orderedAscending ? .left : .right
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
