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
  
  func toStringYYYYMMDD() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd"
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    return dateFormatter.string(from: self)
  }
  
  func toISOString() -> String {
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withInternetDateTime]
    return dateFormatter.string(from: self)
  }
  
  func asDouble() -> Double {
    let calendar = Calendar.autoupdatingCurrent
    let components = calendar
      .dateComponents([Calendar.Component.hour, Calendar.Component.minute], from: self)
    let hour = components.hour ?? 0
    let minute = components.minute ?? 0
    let totalSeconds = hour * 3600 + minute * 60
    return Double(totalSeconds)
  }
}
