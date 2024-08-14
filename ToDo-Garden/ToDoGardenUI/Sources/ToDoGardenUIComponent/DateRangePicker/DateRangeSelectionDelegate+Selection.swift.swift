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
}
