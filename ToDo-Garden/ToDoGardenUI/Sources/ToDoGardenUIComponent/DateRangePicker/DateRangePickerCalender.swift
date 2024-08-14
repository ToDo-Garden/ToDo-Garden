//
//  DateRangePickerCalender.swift
//
//
//  Created by SONG on 8/5/24.
//

import UIKit

import ToDoGardenUIConstant

public final class DateRangePickerCalender: CalendarView {
  
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
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let calendarView = DateRangePickerCalender(model: CalendarView.Model.primary)
  calendarView.widthAnchor.constraint(equalToConstant: 323).isActive = true
  return calendarView
}
#endif
