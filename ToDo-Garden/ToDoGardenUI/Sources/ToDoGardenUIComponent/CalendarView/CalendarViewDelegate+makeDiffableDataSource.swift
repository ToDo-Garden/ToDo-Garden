//
//  CalendarCollectionViewDelegate+DiffableDataSource.swift
//
//
//  Created by Wood on 5/27/24.
//

import UIKit

extension CalendarViewSingleSelectionDelegate {
  func makeDiffableDataSource(
    _ collectionView: UICollectionView,
    with dateFormatter: DateFormatter
  )
  -> UICollectionViewDiffableDataSource<CalendarSection, CalendarItem> {
    return UICollectionViewDiffableDataSource<
      CalendarSection,
      CalendarItem
    >(collectionView: collectionView) { (_, _, _) in
      return UICollectionViewCell()
    }
  }
}

struct CalendarSection: Hashable {
  let firstDay: Date

  static func == (lhs: CalendarSection, rhs: CalendarSection) -> Bool {
    return lhs.firstDay == rhs.firstDay
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(self.firstDay)
  }
}

struct CalendarItem: Hashable {
  let date: Date
  let isThisMonth: Bool

  static func == (lhs: CalendarItem, rhs: CalendarItem) -> Bool {
    return lhs.date == rhs.date && lhs.isThisMonth == rhs.isThisMonth
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(self.date)
    hasher.combine(self.isThisMonth)
  }
}
