//
//  CalendarCollectionViewDelegate+DiffableDataSource.swift
//
//
//  Created by Wood on 5/27/24.
//

import UIKit

extension CalendarViewDelegate {
  func makeDiffableDataSource(
    _ collectionView: UICollectionView,
    with dateFormatter: DateFormatter
  )
  -> UICollectionViewDiffableDataSource<CalendarSection, CalendarItem> {
    return UICollectionViewDiffableDataSource<
      CalendarSection,
      CalendarItem
    >(collectionView: collectionView) { (collectionView, indexPath, dayItem) in
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: CalendarCollectionViewCell.identifier,
        for: indexPath
      ) as? CalendarCollectionViewCell
      else { return UICollectionViewCell() }

      let date = dayItem.date
      let formattedDateString = dateFormatter.string(from: date).split(separator: " ")
      guard let dayString = formattedDateString.last
      else { return cell }

      let isThisMonth = dayItem.isThisMonth
      cell.update(dayString: String(dayString), isThisMonth: isThisMonth)

      return cell
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
