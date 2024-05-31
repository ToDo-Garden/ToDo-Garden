//
//  CalendarViewDelegate.swift
//
//
//  Created by Wood on 5/31/24.
//

import UIKit

import ToDoGardenUIConstant

final class CalendarViewDelegate: NSObject {
  private var collectionView: UICollectionView
  private var collectionViewDataSource: UICollectionViewDiffableDataSource<CalendarSection, CalendarItem>!
  private var calendarDataGenerator: CalendarDataGeneratable
  private var currentIndexPath: IndexPath
  private var collectionViewModel: CalendarView.Model.CollectionView
  private var dateFormatter: DateFormatter

  init(collectionView: UICollectionView) {
    self.collectionView = collectionView
    self.calendarDataGenerator = CalendarDataGenerator(calendar: Calendar.localeUpdated)
    self.currentIndexPath = IndexPath(item: 0, section: 3)
    self.dateFormatter = DateFormatter()
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
}

enum CalendarScrollDirection: Int {
  case left  = -1
  case current = 0
  case right = 1
}
