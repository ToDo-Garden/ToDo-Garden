//
//  DateRangeSelectionDelegate+Selection.swift.swift
//
//
//  Created by SONG on 8/12/24.
//
import Foundation

extension DateRangeSelectionDelegate {
  func updateSelectionState() {
    if startDate != nil {
      if endDate != nil {
        self.currentSelectionState = RangeSelectionState.startAndEnd
      } else {
        self.currentSelectionState = RangeSelectionState.startOnly
      }
    } else {
      self.currentSelectionState = RangeSelectionState.empty
    }
  }
  
  func updateVisibleSelection(isAfterReload: Bool = false) {
    guard let startItem = startDate else { return }
    
    let visibleCells = self.getVisibleCells(isAfterReload: isAfterReload)
    let startIndexPaths = self.getIndexPaths(of: startItem)
    
    if let endItem = endDate {
      self.updateRangeSelection(
        visibleCells: visibleCells,
        startItem: startItem,
        endItem: endItem,
        startIndexPaths: startIndexPaths
      )
    } else {
      self.updateSingleSelection(visibleCells: visibleCells, startIndexPaths: startIndexPaths)
    }
  }
  
  func clearSelection() {
    let selectedIndexPaths = self.collectionView.indexPathsForSelectedItems ?? []
    for indexPath in selectedIndexPaths {
      self.collectionView.deselectItem(at: indexPath, animated: false)
    }
  }
  
  private func getVisibleCells(isAfterReload: Bool) -> [DateRangeCollectionViewCell] {
    if isAfterReload {
      let newSection = 3
      let numberOfItems = self.collectionView.numberOfItems(inSection: newSection)
      return (0..<numberOfItems).compactMap { index in
        self.collectionView.cellForItem(
          at: IndexPath(item: index, section: newSection)
        ) as? DateRangeCollectionViewCell
      }
    } else {
      return self.collectionView.visibleCells.compactMap { $0 as? DateRangeCollectionViewCell }
    }
  }
  
  private func updateSingleSelection(
    visibleCells: [DateRangeCollectionViewCell],
    startIndexPaths: [IndexPath]
  ) {
    for cell in visibleCells {
      guard let indexPath = self.collectionView.indexPath(for: cell) else { continue }
      if startIndexPaths.contains(indexPath) {
        self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        cell.selectionType = DateRangeCollectionViewCell.SelectionType.none
      } else {
        self.collectionView.deselectItem(at: indexPath, animated: false)
        cell.selectionType = DateRangeCollectionViewCell.SelectionType.none
      }
    }
  }
  
  private func updateRangeSelection(
    visibleCells: [DateRangeCollectionViewCell],
    startItem: CalendarItem,
    endItem: CalendarItem,
    startIndexPaths: [IndexPath]
  ) {
    let endIndexPaths = self.getIndexPaths(of: endItem)
    let selectionInfo = SelectionInfo(
      startItem: startItem,
      endItem: endItem,
      startIndexPaths: startIndexPaths,
      endIndexPaths: endIndexPaths
    )
    
    for cell in visibleCells {
      guard let indexPath = self.collectionView.indexPath(for: cell),
        let calendarItem = self.collectionViewDataSource.itemIdentifier(for: indexPath) else { continue }
      
      self.updateCellForRangeSelection(
        cell: cell,
        indexPath: indexPath,
        calendarItem: calendarItem,
        selectionInfo: selectionInfo
      )
    }
  }
  
  private func updateCellForRangeSelection(
    cell: DateRangeCollectionViewCell,
    indexPath: IndexPath,
    calendarItem: CalendarItem,
    selectionInfo: SelectionInfo
  ) {
    if calendarItem.date >= selectionInfo.startItem.date
      && calendarItem.date <= selectionInfo.endItem.date {
      self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
      if selectionInfo.startIndexPaths.contains(indexPath) {
        cell.selectionType = DateRangeCollectionViewCell.SelectionType.right
      } else if selectionInfo.endIndexPaths.contains(indexPath) {
        cell.selectionType = DateRangeCollectionViewCell.SelectionType.left
      } else {
        cell.selectionType = DateRangeCollectionViewCell.SelectionType.full
      }
    } else {
      self.collectionView.deselectItem(at: indexPath, animated: false)
      cell.selectionType = DateRangeCollectionViewCell.SelectionType.none
    }
  }
  
  private struct SelectionInfo {
    let startItem: CalendarItem
    let endItem: CalendarItem
    let startIndexPaths: [IndexPath]
    let endIndexPaths: [IndexPath]
  }
}
