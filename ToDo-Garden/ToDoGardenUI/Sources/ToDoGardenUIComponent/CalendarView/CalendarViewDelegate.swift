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
  private var dateFormatter: DateFormatter

  init(collectionView: UICollectionView) {
    self.collectionView = collectionView
    self.dateFormatter = DateFormatter()
    self.calendarDataGenerator = CalendarDataGenerator(calendar: Calendar.localeUpdated)
    super.init()
    self.setupDateFormatter()
    self.loadInitialMonthSnapshot()
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
