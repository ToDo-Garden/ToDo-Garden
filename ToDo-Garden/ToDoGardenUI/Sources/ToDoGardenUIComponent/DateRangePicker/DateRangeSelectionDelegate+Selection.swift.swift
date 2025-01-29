//
//  DateRangeSelectionDelegate+Selection.swift.swift
//
//
//  Created by SONG on 8/12/24.
//
import Foundation

extension DateRangeSelectionDelegate {
  func updateSelectionState() {
    let hasStartDate = startDate != nil
    let hasEndDate = endDate != nil
    
    let isRangeComplete = hasStartDate && hasEndDate
    let isStartDateOnly = hasStartDate && !hasEndDate
    
    self.currentSelectionState =
    isRangeComplete ? RangeSelectionState.startAndEnd :
    isStartDateOnly ? RangeSelectionState.startOnly :
    RangeSelectionState.empty
  }
  
  func updateSelectionSnapshot() {
    var snapshot = self.collectionViewDataSource.snapshot()
    let sections = snapshot.sectionIdentifiers
    
    for section in sections {
      let items = snapshot.itemIdentifiers(inSection: section)
      for item in items {
        if let startDate = self.startDate,
          let endDate = self.endDate,
          item.date >= startDate.date && item.date <= endDate.date {
          
          if Calendar.current.isDate(item.date, inSameDayAs: startDate.date) {
            item.selectionType = .right
          } else if Calendar.current.isDate(item.date, inSameDayAs: endDate.date) {
            item.selectionType = .left
          } else {
            item.selectionType = .full
          }
        } else if let startDate = self.startDate,
          Calendar.current.isDate(item.date, inSameDayAs: startDate.date) {
          item.selectionType = .single
        } else {
          item.selectionType = .none
        }
      }
      snapshot.reloadItems(items)
    }
    self.collectionViewDataSource.apply(snapshot, animatingDifferences: false)
  }
  
  func clearSelection() {
    let selectedIndexPaths = self.collectionView.indexPathsForSelectedItems ?? []
    for indexPath in selectedIndexPaths {
      self.collectionView.deselectItem(at: indexPath, animated: false)
    }
  }
}
