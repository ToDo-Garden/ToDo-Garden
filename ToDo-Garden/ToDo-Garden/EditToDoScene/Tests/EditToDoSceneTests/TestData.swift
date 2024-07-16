//
//  TestData.swift
//
//
//  Created by Wood on 7/16/24.
//

import Foundation

struct TestData {
  static let defaultCalendar = Calendar(identifier: Calendar.Identifier.gregorian)

  struct EditToDoWorkerTests {
    static let seconds = [
      SecondData(input: 43800, hour: 12, minute: 10),
      SecondData(input: 10140, hour: 2, minute: 49),
      SecondData(input: 79200, hour: 22, minute: 0)
    ]

    static let invalidSeconds = [
      Double(-1),
      Double(85501)
    ]
  }
}

extension TestData.EditToDoWorkerTests {
  struct SecondData {
    let input: Double
    let hour: Int
    let minute: Int
  }
}
