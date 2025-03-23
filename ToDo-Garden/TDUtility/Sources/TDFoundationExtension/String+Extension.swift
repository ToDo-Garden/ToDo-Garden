//
//  String+Extension.swift
//
//
//  Created by SONG on 5/23/24.
//

import Foundation

public extension String {
  func applyTextAttributes(attributes: [NSAttributedString.Key: Any]?) -> NSAttributedString {
    let attributedString = NSAttributedString(
      string: self,
      attributes: attributes
    )
    return attributedString
  }
  
  func toDateISO8601Format() -> Date {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter.date(from: self) ?? Date()
  }
  
  // 2025-03-27T00:00:00+00:00 -> 20250327
  func toYYYYMMDDStringFromISO8601() -> String {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime]
    if let date = formatter.date(from: self) {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyyMMdd"
      return dateFormatter.string(from: date)
    }
    return self
  }
  
  // 2025-03-22 14:22:40 +0000 -> 20250322
  func toYYYYMMDDStringFromISO8601Space() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    if let date = formatter.date(from: self) {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyyMMdd"
      return dateFormatter.string(from: date)
    }
    return self
  }
  
  // 2032년 3월 -> 20320301
  func toYYYYMMDDStringFromYYYYMM() -> String {
    let digits = self.compactMap { $0.isNumber ? $0 : nil }
    let numericString = String(digits)
    
    if numericString.count == 5 {
      let yearPart = numericString.prefix(4)
      let monthPart = numericString.suffix(1)
      return "\(yearPart)0\(monthPart)01"
    } else if numericString.count == 6 {
      return "\(numericString)01"
    } else {
      return self
    }
  }
}
