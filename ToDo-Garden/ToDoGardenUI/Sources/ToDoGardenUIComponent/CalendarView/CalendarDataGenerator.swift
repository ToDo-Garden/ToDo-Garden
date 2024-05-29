//
//  CalendarDataGenerator.swift
//
//
//  Created by Wood on 5/7/24.
//

import Foundation

protocol CalendarDataGeneratable {
  func fetchWeekdaySymbols() -> [String]
  func fetchMonthData(from date: Date, add value: Int) throws -> MonthData
  func compareMonth(date1: Date, with date2: Date) -> ComparisonResult
}

final class CalendarDataGenerator: CalendarDataGeneratable {
  private let calendar: Calendar
  
  init(calendar: Calendar) {
    self.calendar = calendar
  }
  
  func fetchWeekdaySymbols() -> [String] {
    return self.calendar.shortWeekdaySymbols
  }
  
  func fetchMonthData(from date: Date, add value: Int) throws -> MonthData {
    guard let monthToFetch = self.calendar.date(
      byAdding: Calendar.Component.month,
      value: value,
      to: date
    )
    else { throw CalendarDataError.invalidInput }
    let firstDayOfMonth = self.calendar.firstDayOfMonth(from: monthToFetch)
    let dates = try self.monthDays(from: firstDayOfMonth)
    
    return MonthData(firstDayOfMonth: firstDayOfMonth, dates: dates)
  }
  
  func compareMonth(date1: Date, with date2: Date) -> ComparisonResult {
    let comparisonResult = self.calendar.compare(
      date1,
      to: date2,
      toGranularity: Calendar.Component.month
    )
    
    return comparisonResult
  }
}

// MARK: Private Functions

extension CalendarDataGenerator {
  private func monthDays(from day: Date) throws -> [MonthData.Day] {
    let totalMonthDays = try MonthPosition.allCases
      .map { position in
        let params = try position.monthDayParams(day, calendar: self.calendar)
        return self.getMonthDataDays(for: params.range, from: params.firstDay)
      }
      .reduce(into: [MonthData.Day](), +=)
    let dayCountOfWeek = self.calendar.shortWeekdaySymbols.count
    guard totalMonthDays.count % dayCountOfWeek == 0
    else { throw CalendarDataError.failToGenerateData }
    
    return totalMonthDays
  }
  
  private func getMonthDataDays(
    for dateRange: Range<Int>,
    from firstDay: Date
  ) -> [MonthData.Day] {
    return dateRange.map { value in
      let dayOfNextMonth = self.calendar.date(
        byAdding: Calendar.Component.day,
        value: value,
        to: firstDay
      ) ?? Date()
      
      return MonthData.Day(date: dayOfNextMonth, isThisMonth: false)
    }
  }
}

extension CalendarDataGenerator {
  typealias MonthDayParmas = (range: Range<Int>, firstDay: Date)
  enum MonthPosition: CaseIterable {
    case previous
    case current
    case next
    
    func monthDayParams(_ day: Date, calendar: Calendar) throws -> MonthDayParmas {
      switch self {
      case .previous:
        let weekdayCount = calendar.weekdayCount(day)
        let isFirstDayOfWeek = weekdayCount == 1
        guard isFirstDayOfWeek else { throw CalendarDataError.failToGenerateData }
        let startDay = -weekdayCount + 1
        return (startDay..<0, day)
      case .current:
        let firstDayOfNextMonth = try calendar.dayOfNextMonth(day)
        let lastDayOfCurrentMonth = try calendar.lastDayOfMonth(firstDayOfNextMonth)
        let lastDayNumber = calendar.lastDayNumber(lastDay: lastDayOfCurrentMonth)
        return (0..<lastDayNumber, day)
      case .next:
        let firstDayOfNextMonth = try calendar.dayOfNextMonth(day)
        let weekday = calendar.weekdayCount(firstDayOfNextMonth)
        let isFirstDayOfWeek = weekday == 1
        guard isFirstDayOfWeek else { throw CalendarDataError.failToGenerateData }
        let weekdayCount = calendar.shortWeekdaySymbols.count
        let lastDayValue = weekdayCount - weekday + 1
        return (0..<lastDayValue, firstDayOfNextMonth)
      }
    }
  }
}

private extension Calendar {
  func firstDayOfMonth(from date: Date) -> Date {
    let dateComponents = self.dateComponents(
      [
        Calendar.Component.year,
        Calendar.Component.month
      ],
      from: date
    )
    guard let firstDay = self.date(from: dateComponents)
    else { return date }
    
    return firstDay
  }
  
  func dayOfNextMonth(_ day: Date) throws -> Date {
    let date = self.date(
      byAdding: Component.month,
      value: 1,
      to: day
    )
    guard let date else { throw CalendarDataError.unexpected }
    return date
  }
  
  func weekdayCount(_ day: Date) -> Int {
    self.component(Component.weekday, from: day)
  }
  
  func lastDayOfMonth(_ day: Date) throws -> Date {
    guard
      let date = self.date(byAdding: Component.day, value: -1, to: day)
    else { throw CalendarDataError.unexpected }
    return date
  }
  
  func lastDayNumber(lastDay: Date) -> Int {
    component(Component.day, from: lastDay)
  }
}

enum CalendarDataError: Error {
  case invalidInput
  case failToGenerateData
  case unexpected
}
