//
//  CalendarDataGenerator.swift
//
//
//  Created by Wood on 5/7/24.
//

import Foundation

protocol CalendarDataGeneratable {
  func fetchWeekdaySymbols() -> [String]
  func fetchMonthData(from date: Date, add value: Int) -> MonthData?
  func compareMonth(date1: Date, with date2: Date) -> ComparisonResult
}

final class CalendarDataGenerator: CalendarDataGeneratable {
  private var calendar: Calendar

  init(calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)) {
    self.calendar = calendar
    self.setupLocale()
  }

  func fetchWeekdaySymbols() -> [String] {
    return self.calendar.shortWeekdaySymbols
  }

  func fetchMonthData(from date: Date, add value: Int) -> MonthData? {
    guard let monthToFetch = self.calendar.date(
      byAdding: Calendar.Component.month,
      value: value,
      to: date
    )
    else { return nil }

    let firstDayOfMonth = self.getFirstDayOfMonth(from: monthToFetch)
    guard let dates = self.getMonthDates(from: firstDayOfMonth)
    else { return nil }

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
  private func setupLocale() {
    if let userPreferredIdentifier = Locale.preferredLanguages.first {
      let userLocale = Locale(identifier: userPreferredIdentifier)
      self.calendar.locale = userLocale
    } else {
      self.calendar.locale = Locale.autoupdatingCurrent
    }
  }

  private func getFirstDayOfMonth(from date: Date) -> Date {
    let dateComponents = self.calendar.dateComponents(
      [
        Calendar.Component.year,
        Calendar.Component.month
      ],
      from: date
    )

    guard let firstDay = self.calendar.date(from: dateComponents)
    else { return date }

    return firstDay
  }

  private func getMonthDates(from firstDay: Date) -> [MonthData.Day]? {
    let firstDayOfMonth = firstDay
    let previousMonthDays = self.getPreviousMonthDays(from: firstDayOfMonth)
    let nextMonthDays = self.getNextMonthDays(from: firstDayOfMonth)
    let currentMonthDays = self.getCurrentMonthDays(from: firstDayOfMonth)
    guard currentMonthDays.isEmpty == false
    else { return nil }

    let totalMonthDays = previousMonthDays + currentMonthDays + nextMonthDays
    let weekdaySymbolsCount = self.calendar.weekdaySymbols.count
    guard totalMonthDays.count % weekdaySymbolsCount == 0
    else { return nil }

    return totalMonthDays
  }

  private func getPreviousMonthDays(from firstDay: Date) -> [MonthData.Day] {
    let weekdayCount = self.calendar.component(Calendar.Component.weekday, from: firstDay)
    guard weekdayCount != 1 else { return [] }

    let startDay = -weekdayCount + 1
    let dateRange = (startDay..<0)
    let previousMonthDays = self.getMonthDataDays(for: dateRange, from: firstDay)

    return previousMonthDays
  }

  private func getCurrentMonthDays(from firstDay: Date) -> [MonthData.Day] {
    guard let firstDayOfNextMonth = self.calendar.date(
      byAdding: Calendar.Component.month,
      value: 1,
      to: firstDay
    )
    else { return [] }

    guard let lastDayOfCurrentMonth = self.calendar.date(
      byAdding: Calendar.Component.day,
      value: -1,
      to: firstDayOfNextMonth
    )
    else { return [] }

    let lastDayNumber = self.calendar.component(Calendar.Component.day, from: lastDayOfCurrentMonth)
    let dateRange = (0..<lastDayNumber)
    let currentMonthDays = self.getMonthDataDays(for: dateRange, from: firstDay)

    return currentMonthDays
  }

  private func getNextMonthDays(from firstDay: Date) -> [MonthData.Day] {
    guard let firstDayOfNextMonth = self.calendar.date(
      byAdding: Calendar.Component.month,
      value: 1,
      to: firstDay
    )
    else { return [] }

    let weekday = self.calendar.component(Calendar.Component.weekday, from: firstDayOfNextMonth)
    guard weekday != 1 else { return [] }

    let weekdayCount = self.calendar.shortWeekdaySymbols.count
    let lastDayValue = weekdayCount - weekday + 1
    let dateRange = (0..<lastDayValue)
    let nextMonthDays = self.getMonthDataDays(for: dateRange, from: firstDayOfNextMonth)

    return nextMonthDays
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
