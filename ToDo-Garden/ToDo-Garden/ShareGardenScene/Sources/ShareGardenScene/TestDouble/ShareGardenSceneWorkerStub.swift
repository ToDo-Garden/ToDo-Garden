// swiftlint:disable all
//
//  ShareGardenSceneWorkerStub.swift
//  ShareGardenScene
//
//  Created by Noah on 10/1/24.
//

#if DEBUG
import UIKit

import ToDoGardenUIComponent

import SearchGardenSceneAPI
import ShareGardenSceneAPI
import ShareGardenSceneEntity


actor ShareGardenSceneWorkerStub: ShareGardenSceneWorkable {
  
  // MARK: - Friends Garden
  
  var isThrowErrorForFriendsGardenList: Bool = true
  
  func requestFriendsGardenList() async throws -> [ShareGardenScene.FriendsGarden] {
    defer { self.isThrowErrorForFriendsGardenList.toggle() }
    
    let pomodoroRecords = self.makeRandomPomodoroRecords()
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
    
    if self.isThrowErrorForFriendsGardenList {
      throw NSError(domain: "", code: 99999)
    }
    
    return friendsGardens
  }
  
  var isThrowErrorForDelete: Bool = false
  
  func delete(by id: ShareGardenScene.FriendsGarden.ID) async throws {
    defer { self.isThrowErrorForDelete.toggle() }
    
    try await Task.sleep(nanoseconds: 1_000_000_000 )
    
    if self.isThrowErrorForDelete {
      throw NSError(domain: "", code: 99999)
    }
  }
  
  // MARK: - My Garden
  
  var isThrowErrorForRequestMyGarden = true
  
  func requestMyGarden() async throws -> ShareGardenScene.MyGarden {
    defer { self.isThrowErrorForRequestMyGarden.toggle() }
    let pomodoroRecords = self.makeRandomPomodoroRecords()
    
    let myGarden = ShareGardenScene.MyGarden(
      nickname: UUID().uuidString,
      description: UUID().uuidString,
      pomodoroRecords: PomodoroRecordCollection(pomodoroRecords: pomodoroRecords),
      streakCount: 0,
      imageURL: nil
    )
    
    try await Task.sleep(nanoseconds: 2_000_000_000)
    
    if self.isThrowErrorForRequestMyGarden {
      throw NSError(domain: "", code: 99999)
    }
    
    return myGarden
  }
}

extension ShareGardenSceneWorkerStub {
  private func makeRandomPomodoroRecords() -> [PomodoroRecord] {
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
    
    return pomodoroRecords
  }
}

class SearchGardenBuilderStub: @preconcurrency SearchGardenSceneBuildable {
  @MainActor func build() -> any SearchGardenViewControllable {
    return UIViewController() as! SearchGardenViewControllable
  }
}
#endif

// swiftlint:enable all
