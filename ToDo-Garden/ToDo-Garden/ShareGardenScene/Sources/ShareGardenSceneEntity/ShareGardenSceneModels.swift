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
  
  public struct MyGarden: Sendable {
    public let nickname: String
    public let description: String
    public let pomodoroRecords: PomodoroRecordCollection
    
    public init(
      nickname: String,
      description: String,
      pomodoroRecords: PomodoroRecordCollection
    ) {
      self.nickname = nickname
      self.description = description
      self.pomodoroRecords = pomodoroRecords
    }
  }
  
  // MARK: Use cases
  
  public enum RequestFriendsGardenList {
    public struct Response: Sendable {
      public let friendsGardenList: [FriendsGarden]
      
      public init(friendsGardenList: [FriendsGarden]) {
        self.friendsGardenList = friendsGardenList
      }
    }
    
    public struct ViewModel: Sendable {
      public let identifiers: [UUID]
      
      public init(identifiers: [UUID]) {
        self.identifiers = identifiers
      }
    }
  }
}
