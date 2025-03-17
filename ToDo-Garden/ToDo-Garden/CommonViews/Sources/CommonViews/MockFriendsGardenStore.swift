//
//  MockFriendsGardenStore.swift
//  CommonViews
//
//  Created by SONG on 3/14/25.
//
import Foundation

import ShareGardenScene
import ShareGardenSceneEntity
import ToDoGardenUIComponent

class MockFriendsGardenStore: FriendsGardenStore {
  func fetch(
    by id: ShareGardenSceneEntity.ShareGardenScene.FriendsGarden.ID
  ) -> ShareGardenSceneEntity.ShareGardenScene.FriendsGarden? {
    ShareGardenSceneEntity.ShareGardenScene.FriendsGarden(
      nickname: "김첨지",
      focusStreakDays: Int.zero,
      pomodoroRecords: PomodoroRecordCollection())
  }
  
  func delete(by id: ShareGardenSceneEntity.ShareGardenScene.FriendsGarden.ID, completion: @escaping () -> Void) {
    return
  }
}
