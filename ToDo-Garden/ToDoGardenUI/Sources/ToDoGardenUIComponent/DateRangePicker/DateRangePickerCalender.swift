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

  }
  
  @available(*, deprecated)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
