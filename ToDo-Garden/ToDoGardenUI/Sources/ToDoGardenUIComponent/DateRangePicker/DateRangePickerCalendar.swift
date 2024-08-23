//
//  DateRangePickerCalendar.swift
//
//
//  Created by SONG on 8/5/24.
//

import UIKit

public final class DateRangePickerCalendar: CalendarView {
  
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

  func getDateRange(_ closure: @escaping (Date?, Date?) -> Void) {
    guard let dateRangePickerDelegate = self.calendarViewDelegate
    as? DateRangeSelectionDelegate else { return }

    dateRangePickerDelegate.registerSelectedRangeSendingClosure(closure)
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let calendarView = DateRangePickerCalendar(model: CalendarView.Model.primary)
  calendarView.widthAnchor.constraint(equalToConstant: 323).isActive = true
  calendarView.getDateRange { startDate, endDate in
    print(startDate, endDate)
  }
  return calendarView
}
#endif
