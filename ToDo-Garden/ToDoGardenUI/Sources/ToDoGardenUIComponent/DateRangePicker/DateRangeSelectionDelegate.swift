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
  
  private var lastScrollTime: TimeInterval = 0
  private var selectedRangeSendingClosure: ((Date?, Date?) -> Void)?

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
    self.afterReloadSection = { [weak self] in
      self?.collectionView.layoutIfNeeded()
      self?.updateVisibleSelection(isAfterReload: true)
      
    }
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
    case RangeSelectionState.startOnly:
      guard let startDate = self.startDate else { return }
      if selectedItem.date < startDate.date {
        self.clearSelection()
        self.startDate = selectedItem
        self.endDate = nil
      } else {
        self.endDate = selectedItem
      }
    case RangeSelectionState.empty:
      self.startDate = selectedItem
    }
    
    self.updateSelectionState()
    self.updateVisibleSelection()
  }
  
  // MARK: - UIScrollViewDelegate Methods
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let debounceInterval: TimeInterval = 0.07
    let currentTime = Date().timeIntervalSince1970
    if currentTime - lastScrollTime >= debounceInterval {
      self.updateVisibleSelection()
      self.lastScrollTime = currentTime
    }
  }
}

// MARK: Selected Range Sending Closure

extension DateRangeSelectionDelegate {
  /// 선택된 범위의 시작일과 종료일을 DateRangePickerCalendar에 전달하는 클로저를 등록하는 함수입니다.
  func registerSelectedRangeSendingClosure(_ closure: @escaping (Date?, Date?) -> Void) {
    self.selectedRangeSendingClosure = closure
  }
}
