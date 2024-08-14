//
//  DateRangeSelectionDelegate+IndexPathUtils.swift
//
//
//  Created by SONG on 8/12/24.
//

import Foundation

extension DateRangeSelectionDelegate {
  func getIndexPaths(of item: CalendarItem) -> [IndexPath] {
    var foundIndexPaths: [IndexPath] = []
    
    for section in 0..<self.collectionView.numberOfSections {
      for itemIndex in 0..<self.collectionView.numberOfItems(inSection: section) {
        let indexPath = IndexPath(item: itemIndex, section: section)
        if let calendarItem = self.collectionViewDataSource.itemIdentifier(for: indexPath),
          Calendar.current.isDate(calendarItem.date, inSameDayAs: item.date) {
          foundIndexPaths.append(indexPath)
          
          if foundIndexPaths.count == 2 {
            return foundIndexPaths
          }
        }
      }
    }
    return foundIndexPaths
  }
}
