//
//  StaticObjects.swift
//  AppCore
//
//  Created by SONG on 2/4/25.
//

import Foundation

import EditToDoScene
import HomeScene
import HomeSceneEntity
import HTTPClient
import ManageGroupScene
import PostGroupScene
import ShareGardenScene
import SignUpScene
import TDFoundation
import TimerScene
import TimerSceneEntity

// MARK: HOME SCENE
extension HomeSceneBuilder.Dependency {
  @MainActor
  public static let live = HomeSceneBuilder.Dependency.init(
    homeSceneWorker: HomeSceneWorker(
      httpClient: HTTPClient.live,
      homeStorage: JSONStorage<HomeScene.TodoBatchItem>(fileName: "todolistBatch.json")
    ),
    manageGroupSceneBuilder: ManageGroupSceneBuilder.init(dependency: .live),
    editToDoSceneBuilder: EditToDoSceneBuilder(dependency: .live),
    timerSceneBuilder: TimerSceneBuilder(dependency: .live)
  )
}

// MARK: TIMER SCENE
extension TimerSceneBuilder.Dependency {
  @MainActor
  public static let live = TimerSceneBuilder.Dependency(
    timerWorker: TimerSceneWorker.live,
    storageWorker: TimerStorageWorker.live,
    notificationManager: NotificationManager.shared,
    networkRetryManager: NetworkRetryManager()
  )
}

extension TimerStorageWorker {
  static let live = TimerStorageWorker(
    httpClient: HTTPClient.live,
    timerStorage: JSONStorage<TimerScene.PomodoroDTO>(fileName: "pomodoros.json")
  )
}

// MARK: SHARE GARDEN SCENE
extension ShareGardenSceneBuilder.Dependency {
  public static let live = ShareGardenSceneBuilder.Dependency.init(
    shareGardenSceneWorker: ShareGardenSceneWorker(httpClient: HTTPClient.live)
  )
}

// MARK: MANAGE GROUP SCENE
extension ManageGroupSceneBuilder.Dependency {
  static let live = ManageGroupSceneBuilder.Dependency.init(
    manageGroupWorker: ManageGroupWorker(httpClient: HTTPClient.live),
    postGroupSceneBuilder: PostGroupSceneBuilder.init(dependency: .live)
  )
}

// MARK: POST GROUP SCENE
extension PostGroupSceneBuilder.Dependency {
  static let live = PostGroupSceneBuilder.Dependency.init(postGroupWorker: PostGroupWorker())
}

// MARK: EDIT TODO SCENE
extension EditToDoSceneBuilder.Dependency {
  static let live = EditToDoSceneBuilder.Dependency.init(editToDoWorker: EditToDoWorker(httpClient: HTTPClient.live))
}

// MARK: SIGN UP SCENE
extension SignUpSceneBuilder.Dependency {
  static let live = SignUpSceneBuilder.Dependency.init(signUpWorker: SignUpWorker(httpClient: HTTPClient.live))
}
