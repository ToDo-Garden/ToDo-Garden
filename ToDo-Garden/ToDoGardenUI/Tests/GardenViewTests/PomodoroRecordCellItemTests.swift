//
//  PomodoroRecordCellItemTests.swift
//
//
//  Created by Noah on 6/27/24.
//

@testable import ToDoGardenUIComponent

import Foundation
import Testing

extension Tag {
  @Tag static let gardenView: Self
}

@Suite(.tags(.gardenView))
struct PomodoroRecordCellItemTests {
  @Test(arguments: [
    (
      dates: [
        "2023/05/31",
        "2023/06/01",
        "2023/06/02"
      ],
      expected: "6/1"
    ),
    (
      dates: [
        "2023/07/31",
        "2023/08/01",
        "2023/08/02"
      ],
      expected: "8/1"
    ),
    (
      dates: [
        "2023/09/02",
        "2023/09/03"
      ],
      expected: nil
    )
  ])
  // swiftlint:disable identifier_name
  private func 첫번째날이_배열에_포함되었을경우_올바른_값을_반환하는가(
    dates: [String],
    expected: String?
  ) {
    // Given
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    let dateObjects = dates.compactMap { dateFormatter.date(from: $0) }
    let item = PomodoroRecordCellItem(
      dates: dateObjects,
      pomodoroLevels: Array(repeating: PomodoroLevel.high, count: dates.count)
    )
    
    // When
    let result = item.formattedFirstDayOfMonth()
    
    // Then
    #expect(
      result == expected,
      "포맷된 날짜가 올바르지 않습니다. 기대값: \(expected ?? "nil"), 실제값: \(result ?? "nil")"
    )
  }
  // swiftlint:enable identifier_name
}
