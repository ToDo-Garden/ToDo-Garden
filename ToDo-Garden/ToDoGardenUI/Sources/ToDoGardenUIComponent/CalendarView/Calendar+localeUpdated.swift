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
    calendar.locale = Locale.korea
    return calendar
  }
}
