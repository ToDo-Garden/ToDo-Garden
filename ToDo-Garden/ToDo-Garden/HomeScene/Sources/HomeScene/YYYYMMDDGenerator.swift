//
//  YYMMDDGenerator.swift
//  HomeScene
//
//  Created by SONG on 4/1/25.
//

import Foundation

// 20250205 -> [20250201,20250202,...,20250228]
final class YYYYMMDDGenerator {
  static func generateDates(for yyyymmdd: String) -> [String]? {
    guard yyyymmdd.count == 8 else { return nil }
    
    let yearString = yyyymmdd.prefix(4)
    let monthString = yyyymmdd.prefix(6).suffix(2)
    
    guard let year = Int(yearString), let month = Int(monthString), (1...12).contains(month) else {
      return nil
    }
    
    let calendar = Calendar.current
    var dateComponents = DateComponents()
    dateComponents.year = year
    dateComponents.month = month
    
    guard let firstDayOfMonth = calendar.date(from: dateComponents),
      let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth) else {
      return nil
    }
    
    let daysInMonth = range.count
    var dates: [String] = []
    
    for day in 1...daysInMonth {
      let dayString = String(format: "%02d", day)
      dates.append("\(yearString)\(monthString)\(dayString)")
    }
    
    return dates
  }
}
