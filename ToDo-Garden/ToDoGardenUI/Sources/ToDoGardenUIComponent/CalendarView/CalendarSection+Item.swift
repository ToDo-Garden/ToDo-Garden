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

class CalendarItem: Hashable {
  let date: Date
  let isThisMonth: Bool
  var selectionType: SelectionType = .none
  
  init(date: Date, isThisMonth: Bool) {
    self.date = date
    self.isThisMonth = isThisMonth
  }

  static func == (lhs: CalendarItem, rhs: CalendarItem) -> Bool {
    return lhs.date == rhs.date && lhs.isThisMonth == rhs.isThisMonth
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(self.date)
    hasher.combine(self.isThisMonth)
  }
}

enum SelectionType {
  case none
  case full
  case left
  case right
  case single
}
