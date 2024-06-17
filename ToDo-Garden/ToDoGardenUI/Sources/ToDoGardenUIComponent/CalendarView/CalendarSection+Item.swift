//
//  CalendarSection+Item.swift
//  
//
//  Created by Wood on 6/17/24.
//

import Foundation

struct CalendarSection: Hashable {
  let firstDay: Date

  static func == (lhs: CalendarSection, rhs: CalendarSection) -> Bool {
    return lhs.firstDay == rhs.firstDay
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(self.firstDay)
  }
}

struct CalendarItem: Hashable {
  let date: Date
  let isThisMonth: Bool

  static func == (lhs: CalendarItem, rhs: CalendarItem) -> Bool {
    return lhs.date == rhs.date && lhs.isThisMonth == rhs.isThisMonth
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(self.date)
    hasher.combine(self.isThisMonth)
  }
}
