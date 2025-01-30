//
//  DateRangePickerCalendar.swift
//
//
//  Created by SONG on 8/5/24.
//

import UIKit

public final class DateRangePickerCalendar: CalendarView {
  var actionAfterSelection: ((Date?, Date?) -> Void)?
  
  public override init(model: CalendarView.Model) {
    super.init(model: model)
    self.calendarViewDelegate = DateRangeSelectionDelegate(
      collectionView: self.dateCollectionView,
      collectionViewLayoutModel: model.collectionViewLayout,
      cellIdentifier: DateRangeCollectionViewCell.identifier
    )
    self.setupCollectionViewScrollDelegate()
    self.dateCollectionView.delegate = self.calendarViewDelegate
    self.dateCollectionView.allowsMultipleSelection = true
    self.layer.borderWidth = CGFloat.zero
    self.dateCollectionView.register(
      DateRangeCollectionViewCell.self,
      forCellWithReuseIdentifier: DateRangeCollectionViewCell.identifier
    )
  }
  
  @available(*, deprecated)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func getStartDate() -> Date? {
    (self.calendarViewDelegate as? DateRangeSelectionDelegate)?.startDate?.date
  }
  
  func getEndDate() -> Date? {
    (self.calendarViewDelegate as? DateRangeSelectionDelegate)?.endDate?.date
  }
  
  func register(_ picker: DateRangePresentDelegate) {
    (self.calendarViewDelegate as? DateRangeSelectionDelegate)?.dateRangePresentDelegate = picker
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let calendarView = DateRangePickerCalendar(model: CalendarView.Model.primary)
  calendarView.widthAnchor.constraint(equalToConstant: 323).isActive = true
  return calendarView
}
#endif
