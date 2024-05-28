//
//  CalendarDataGenerator.swift
//
//
//  Created by Wood on 5/7/24.
//

import Foundation

final class CalendarDataGenerator {
  private var calendar: Calendar

  init(calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)) {
    self.calendar = calendar
    self.setupLocale()
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
}
