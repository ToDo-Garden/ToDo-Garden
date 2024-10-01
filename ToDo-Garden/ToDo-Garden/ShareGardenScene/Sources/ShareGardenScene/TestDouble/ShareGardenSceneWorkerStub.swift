// swiftlint:disable all
//
//  ShareGardenSceneWorkerStub.swift
//  ShareGardenScene
//
//  Created by Noah on 10/1/24.
//

#if DEBUG
import Foundation

import ToDoGardenUIComponent

import ShareGardenSceneAPI
import ShareGardenSceneEntity


final class ShareGardenSceneWorkerStub: ShareGardenSceneWorkable {
  func requestFriendsGardenList() async throws -> [ShareGardenScene.FriendsGarden] {
    var pomodoroRecords = [PomodoroRecord]()

    let calendar = Calendar.current

    let startDateComponents = DateComponents(year: 2024, month: 6, day: 14)
    let date = calendar.date(from: startDateComponents)!

    for i in 0..<140 {
      let currentDate = calendar.date(byAdding: .day, value: i, to: date)!
      let pomodoroCount = Int.random(in: 0...10) // Random pomodoro count between 0 and 10
      let formattedDate = calendar.date(
        from: DateComponents(
          year: calendar.component(.year, from: currentDate),
          month: calendar.component(.month, from: currentDate),
          day: calendar.component(.day, from: currentDate)
        )
      )!
      let pomodoroRecord = PomodoroRecord(date: formattedDate, pomodoroCount: pomodoroCount)
      pomodoroRecords.append(pomodoroRecord)
    }

    let nicknames = ["강운", "노아", "우드", "울버린"]
    var friendsGardens = [ShareGardenScene.FriendsGarden]()

    for _ in 0..<25 {
      let randomNickname = nicknames.randomElement()!
      let randomFocusStreakDays = Int.random(in: 1...30)
      let randomPomodoroRecords = PomodoroRecordCollection(pomodoroRecords: pomodoroRecords.shuffled())

      let friendsGarden = ShareGardenScene.FriendsGarden(
        nickname: randomNickname,
        focusStreakDays: randomFocusStreakDays,
        pomodoroRecords: randomPomodoroRecords
      )
      friendsGardens.append(friendsGarden)
    }

    try await Task.sleep(nanoseconds: 2_000_000_000 )

    return friendsGardens
  }
}
#endif

// swiftlint:enable all
