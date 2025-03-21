//
//  Date+Extension.swift
//
//
//  Created by SONG on 11/12/24.
//

import Foundation

public extension Date {
  func toStringDefaultFormat() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy.MM.dd"
    return dateFormatter.string(from: self)
  }
  
  func toStringDefaultFormatWithSpace() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy. MM. dd"
    return dateFormatter.string(from: self)
  }
  
  func toStringDateFormatWithDash() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    return dateFormatter.string(from: self)
  }
}
