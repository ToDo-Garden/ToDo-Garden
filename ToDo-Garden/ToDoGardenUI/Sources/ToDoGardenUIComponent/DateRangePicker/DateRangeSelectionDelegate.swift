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
  
}
