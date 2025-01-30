//
//  DateRangePicker.swift
//  ToDoGardenUI
//
//  Created by SONG on 1/31/25.
//

import UIKit

import TDFoundationExtension

public final class DateRangePicker: UIView {
  private let dateRangeHeaderView: DateRangePickerHeaderView
  private let dateRangePickerCalendar: DateRangePickerCalendar
  
  public var didChangeDateRange: ((Date?, Date?) -> Void)?
  
  public init() {
    self.dateRangeHeaderView = DateRangePickerHeaderView()
    self.dateRangePickerCalendar = DateRangePickerCalendar(model: CalendarView.Model.primary)
    super.init(frame: CGRect.zero)
    self.setup()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func getStartDate() -> Date? {
    self.dateRangePickerCalendar.getStartDate()
  }
  
  public func getEndDate() -> Date? {
    self.dateRangePickerCalendar.getEndDate()
  }
  
  private func setup() {
    self.setupHeader()
    self.setupCalendar()
  }
  
  private func setupHeader() {
    self.dateRangeHeaderView.clearDates()
    self.addSubview(self.dateRangeHeaderView)
    self.dateRangeHeaderView.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        self.dateRangeHeaderView.topAnchor.constraint(equalTo: self.topAnchor),
        self.dateRangeHeaderView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
      ]
    )
  }
  
  private func setupCalendar() {
    self.dateRangePickerCalendar.register(self)
    self.addSubview(self.dateRangePickerCalendar)
    self.dateRangePickerCalendar.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        self.dateRangePickerCalendar.topAnchor.constraint(
          equalTo: self.dateRangeHeaderView.bottomAnchor,
          constant: 13.0
        ),
        self.dateRangePickerCalendar.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        self.dateRangePickerCalendar.widthAnchor.constraint(equalToConstant: 323.0)
      ]
    )
  }
}

extension DateRangePicker: DateRangePresentDelegate {
  func didTouchCell(startDate: Date?, endDate: Date?) {
    self.updateHeaderView(startDate: startDate, endDate: endDate)
    self.didChangeDateRange?(startDate, endDate)
  }
  
  private func updateHeaderView(startDate: Date?, endDate: Date?) {
    let startDateString = startDate?.toStringDefaultFormatWithSpace() ?? ""
    let endDateString = endDate?.toStringDefaultFormatWithSpace() ?? ""
    
    self.dateRangeHeaderView.updateStartDate(to: startDateString)
    self.dateRangeHeaderView.updateEndDate(to: endDateString)
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let rangePicker = DateRangePicker()
  rangePicker.usingAutolayout()
  rangePicker.widthAnchor.constraint(equalToConstant: 336).isActive = true
  rangePicker.heightAnchor.constraint(equalToConstant: 400).isActive = true
  return rangePicker
}
#endif
