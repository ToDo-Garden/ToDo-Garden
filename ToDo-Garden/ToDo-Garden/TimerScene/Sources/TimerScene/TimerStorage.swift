//
//  TimerStorage.swift
//  TimerScene
//
//  Created by SONG on 1/22/25.
//

import Foundation

import TimerSceneEntity

final class TimerStorage: @unchecked Sendable {
  private let fileManager: FileManager
  private let documentsURL: URL
  private var storageURL: URL {
    self.documentsURL.appendingPathComponent("pomodoros.json")
  }
  
  init() throws {
    self.fileManager = FileManager.default
    self.documentsURL = try self.fileManager.url(
      for: .documentDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: true
    )
  }
  
  // MARK: - Load & Save Methods
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
