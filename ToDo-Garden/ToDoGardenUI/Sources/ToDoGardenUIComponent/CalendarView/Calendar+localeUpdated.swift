//
//  Calendar+localeUpdated.swift
//  
//
//  Created by Wood on 5/31/24.
//

import Foundation

extension Calendar {
  static var localeUpdated: Self {
    var calendar = Self(identifier: Identifier.gregorian)
    if let localeIdentifier = Locale.preferredLanguages.first {
      calendar.locale = Locale(identifier: localeIdentifier)
    } else {
      calendar.locale = Locale.autoupdatingCurrent
    }

    return calendar
  }
}
