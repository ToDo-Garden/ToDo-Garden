//
//  ShareGardenSceneModels.swift
//
//
//  Created by Noah on 7/4/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import Foundation
// TODO: - PomodoroRecordCollection 이관 예정
import ToDoGardenUIComponent

public enum ShareGardenScene {
  // MARK: Use cases
  
  public struct FriendsGarden: Identifiable, Sendable {
    public let id: UUID
    public let nickname: String
    public let focusStreakDays: Int
    public let pomodoroRecords: PomodoroRecordCollection
    
    public init(
      id: UUID = UUID(),
      nickname: String,
      focusStreakDays: Int,
      pomodoroRecords: PomodoroRecordCollection
    ) {
      self.id = id
      self.nickname = nickname
      self.focusStreakDays = focusStreakDays
      self.pomodoroRecords = pomodoroRecords
    }
  }
}
