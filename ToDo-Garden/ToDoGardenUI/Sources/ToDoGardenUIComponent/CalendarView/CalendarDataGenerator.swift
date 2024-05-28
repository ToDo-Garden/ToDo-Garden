//
//  CalendarDataGenerator.swift
//
//
//  Created by Wood on 5/7/24.
//

import Foundation

protocol CalendarDataGeneratable {
  func fetchWeekdaySymbols() -> [String]
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
