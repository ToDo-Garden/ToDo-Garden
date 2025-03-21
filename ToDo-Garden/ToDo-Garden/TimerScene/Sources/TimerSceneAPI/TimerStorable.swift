//
//  TimerStorable.swift
//  TimerScene
//
//  Created by SONG on 1/27/25.
//

import TimerSceneEntity

public protocol TimerStorable: Sendable {
  func saveCompletedTimer(groupId: String, duration: Int) throws
  func deleteAllPomodoros() throws
  func getAsDTO() throws -> [TimerScene.PomodoroDTO]
}
