//
//  DateRangeSelectionDelegate.swift
//
//
//  Created by SONG on 8/12/24.
//

import UIKit

final class DateRangeSelectionDelegate: CalendarViewSingleSelectionDelegate {
  var currentSelectionState: RangeSelectionState
  var startDate: CalendarItem?
  var endDate: CalendarItem?
  private var selectedDateRange: (start: Date, end: Date)?
  
  override init(
    collectionView: UICollectionView,
    collectionViewLayoutModel: CalendarView.Model.CollectionViewLayout,
    cellIdentifier: String
  ) {
    collectionView.isScrollEnabled = false
    self.currentSelectionState = RangeSelectionState.empty
    super.init(
      collectionView: collectionView,
      collectionViewLayoutModel: collectionViewLayoutModel,
      cellIdentifier: cellIdentifier
    )
  }
  
  // MARK: - UICollectionViewDelegate Methods
  
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    guard let touchedItem = self.collectionViewDataSource.itemIdentifier(for: indexPath) else { return }
    
    switch self.currentSelectionState {
    case RangeSelectionState.startAndEnd:
      self.clearSelection()
      self.startDate = touchedItem
      self.endDate = nil
      collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
    case RangeSelectionState.startOnly:
      collectionView.deselectItem(at: indexPath, animated: false)
      self.startDate = nil
      self.endDate = nil
      self.clearSelection()
    case RangeSelectionState.empty:
      break
    }
    
    self.updateSelectionState()
    self.updateVisibleSelection()
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    super.collectionView(collectionView, didSelectItemAt: indexPath)
    
    guard let selectedItem = self.collectionViewDataSource.itemIdentifier(for: indexPath) else { return }
    
    switch self.currentSelectionState {
    case RangeSelectionState.startAndEnd:
      self.clearSelection()
      self.startDate = selectedItem
      self.endDate = nil
      self.selectedDateRange = (start: selectedItem.date, end: selectedItem.date)
    case RangeSelectionState.startOnly:
      guard let startDate = self.startDate else { return }
      if selectedItem.date < startDate.date {
        self.clearSelection()
        self.startDate = selectedItem
        self.endDate = nil
        self.selectedDateRange = (start: selectedItem.date, end: selectedItem.date)
      } else {
        self.endDate = selectedItem
        self.selectedDateRange = (start: startDate.date, end: selectedItem.date)
      }
    case RangeSelectionState.empty:
      self.startDate = selectedItem
      self.selectedDateRange = (start: selectedItem.date, end: selectedItem.date)
    }
    
    self.updateSelectionState()
    self.updateVisibleSelection()
  }
}
