//
//  MonthData.swift
//
//
//  Created by Wood on 5/23/24.
//

import Foundation

struct MonthData {
  struct Day {
    let date: Date
    let isThisMonth: Bool
  }

  let firstDayOfMonth: Date
  let dates: [Day]
}
