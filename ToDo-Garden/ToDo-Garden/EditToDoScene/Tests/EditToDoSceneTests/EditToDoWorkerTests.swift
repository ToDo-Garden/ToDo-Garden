//
//  EditToDoWorkerTests.swift
//
//
//  Created by Wood on 7/16/24.
//

import Foundation
import Testing

@testable import EditToDoScene

struct EditToDoWorkerTests {
  private let editToDoWorker = EditToDoWorker(calendar: TestData.defaultCalendar)

  @Test(
    "make dates from valid seconds",
    arguments: TestData.EditToDoWorkerTests.seconds
  ) func test_make_dates_from_valid_seconds(
    secondData: TestData.EditToDoWorkerTests.SecondData
  ) throws {
    let second = secondData.input
    let expectedResultHour = secondData.hour
    let expectedResultMinute = secondData.minute

    let date = try #require(self.editToDoWorker.makeDate(from: second))
    let hour = TestData.defaultCalendar.component(Calendar.Component.hour, from: date)
    let minute = TestData.defaultCalendar.component(Calendar.Component.minute, from: date)

    #expect(hour == expectedResultHour)
    #expect(minute == expectedResultMinute)
  }

  @Test(
    "make dates from invalid seconds return nil",
    arguments: TestData.EditToDoWorkerTests.invalidSeconds
  ) func test_make_dates_from_invalid_seconds_return_nil(second: Double) throws {
    let date = self.editToDoWorker.makeDate(from: second)

    #expect(date == nil)
  }
}
