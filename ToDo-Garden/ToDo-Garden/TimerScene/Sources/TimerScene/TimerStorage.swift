//
//  TimerStorage.swift
//  TimerScene
//
//  Created by SONG on 1/22/25.
//

import Foundation

import TimerSceneAPI
import TimerSceneEntity

// TODO: GRDB로 대체될 예정입니다
final class TimerStorage: TimerStorable, @unchecked Sendable {
  private let fileManager: FileManager
  private let documentsURL: URL
  private var storageURL: URL {
    self.documentsURL.appendingPathComponent("pomodoros.json")
  }
  
  init() {
    self.fileManager = FileManager.default
    
    guard let documentsURL = FileManager.default.urls(
      for: .documentDirectory,
      in: .userDomainMask).first else {
      fatalError("Can not access documents directory.")
    }
    
    self.documentsURL = documentsURL
  }
  
  func saveCompletedTimer(groupId: String, duration: Int) throws {
    let today = self.getCurrentDateString()
    
    var pomodoros = try self.loadPomodorosJSON()
    
    if let index = pomodoros.firstIndex(where: {
      $0.focusGroupId == groupId && $0.focusDate == today
    }) {
      self.updateExistingPomodoro(&pomodoros[index], with: duration)
    } else {
      self.addNewPomodoro(&pomodoros, groupId: groupId, date: today, duration: duration)
    }
    
    try self.savePomodorosAsJSON(pomodoros)
  }
  
  func deleteAllPomodoros() throws {
    try self.savePomodorosAsJSON([])
  }
  
  func getAsDTO() throws -> TimerScene.FocusTimeRequestDTO {
    let pomodoros = try self.loadPomodorosJSON()
    return TimerScene.FocusTimeRequestDTO(pomodoros: pomodoros)
  }
}

// MARK: - Private Methods
extension TimerStorage {
  private func loadPomodorosJSON() throws -> [TimerScene.PomodoroDTO] {
    guard self.fileManager.fileExists(atPath: self.storageURL.path) else {
      return []
    }
    
    let data = try Data(contentsOf: self.storageURL)
    return try JSONDecoder().decode([TimerScene.PomodoroDTO].self, from: data)
  }
  
  private func savePomodorosAsJSON(_ pomodoros: [TimerScene.PomodoroDTO]) throws {
    let data = try JSONEncoder().encode(pomodoros)
    try data.write(to: self.storageURL)
  }
  
  private func getCurrentDateString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: Date())
  }
  
  private func updateExistingPomodoro(_ pomodoro: inout TimerScene.PomodoroDTO, with duration: Int) {
    pomodoro.focusTime.append(duration)
    pomodoro.focusTime.sort()
  }
  
  private func addNewPomodoro(
    _ pomodoros: inout [TimerScene.PomodoroDTO],
    groupId: String,
    date: String,
    duration: Int
  ) {
    let newPomodoro = TimerScene.PomodoroDTO(
      focusGroupId: groupId,
      focusDate: date,
      focusTime: [duration]
    )
    pomodoros.append(newPomodoro)
  }
}

extension TimerStorage {
  static let live = TimerStorage()
}
