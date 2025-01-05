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
}
