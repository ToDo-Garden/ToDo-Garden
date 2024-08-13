//
//  CalendarViewSingleSelectionDelegate+DiffableDataSource.swift
//
//
//  Created by Wood on 5/27/24.
//

import UIKit

extension CalendarViewSingleSelectionDelegate {
  func makeDiffableDataSource(identifier: String)
  -> UICollectionViewDiffableDataSource<CalendarSection, CalendarItem> {
    return UICollectionViewDiffableDataSource<
      CalendarSection,
      CalendarItem
    >(collectionView: self.collectionView) { (collectionView, indexPath, dayItem) in
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: identifier,
        for: indexPath
      ) as? CalendarCollectionViewCell
      else { return UICollectionViewCell() }
      
      let dayString = self.makeDayString(from: dayItem.date)
      cell.updateText(with: dayString)
      let isThisMonth = dayItem.isThisMonth
      cell.updateTextColor(with: isThisMonth)
      
      self.updateCellToSelected(with: self.selectedItem)
      return cell
    }
  }

  private func makeDayString(from date: Date) -> String {
    let formattedDateString = self.dateFormatter.string(from: date).split(separator: " ")
    guard let dayString = formattedDateString.last
    else { return "" }
    
    return String(dayString)
  }

  private func updateCellToSelected(with item: CalendarItem?) {
    guard let selectedItem = item
    else { return }
    
    guard let indexPath = self.getIndexPath(of: selectedItem)
    else { return }
    
    self.collectionView.selectItem(
      at: indexPath,
      animated: true,
      scrollPosition: []
    )
  }

  private func getIndexPath(of item: CalendarItem) -> IndexPath? {
    let snapshot = self.collectionViewDataSource.snapshot()
    let section = snapshot.sectionIdentifiers[self.currentIndexPath.section]
    let indexOfItem = snapshot.itemIdentifiers(inSection: section).firstIndex { (calendarItem: CalendarItem) in
      return item.date == calendarItem.date
    }
    
    if let itemIndex = indexOfItem {
      return IndexPath(item: itemIndex, section: self.currentIndexPath.section)
    } else {
      return nil
    }
  }
}
