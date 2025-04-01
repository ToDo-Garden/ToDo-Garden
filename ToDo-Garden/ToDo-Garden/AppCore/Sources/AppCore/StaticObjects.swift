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
import MyStatsScene
import PostGroupScene
import SearchGardenScene
import SharedEntity
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
<<<<<<< HEAD
      httpClient: HTTPClient.live,
      homeStorage: JSONStorage<SharedEntity.TodoBatchItem>(fileName: "todolistBatch.json")
=======
      httpClient: HTTPClient.live
>>>>>>> 94ab023d (#907: 정적객체 수정)
    ),
    manageGroupSceneBuilder: ManageGroupSceneBuilder.init(dependency: .live),
    editToDoSceneBuilder: EditToDoSceneBuilder(dependency: .live),
    timerSceneBuilder: TimerSceneBuilder(dependency: .live),
    retryManager: NetworkRetryManager()
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
  @MainActor
  public static let live = ShareGardenSceneBuilder.Dependency.init(
    shareGardenSceneWorker: ShareGardenSceneWorker(httpClient: HTTPClient.live),
    searchGardenSceneBuilder: SearchGardenSceneBuilder(
      dependency: .init(
        searchGardenWorker: SearchGardenWorker.init(httpclient: HTTPClient.live))
    ),
    myStatsSceneBuilder: MyStatsSceneBuilder.init(
      dependency: .init(myStatsWorker: MyStatsWorker(httpClient: HTTPClient.live))
    )
  )
}

// MARK: MANAGE GROUP SCENE
extension ManageGroupSceneBuilder.Dependency {
  @MainActor
  static let live = ManageGroupSceneBuilder.Dependency.init(
    manageGroupWorker: ManageGroupWorker(httpClient: HTTPClient.live),
    postGroupSceneBuilder: PostGroupSceneBuilder.init(dependency: .live)
  )
}

// MARK: POST GROUP SCENE
extension PostGroupSceneBuilder.Dependency {
  @MainActor
  static let live = PostGroupSceneBuilder.Dependency.init(postGroupWorker: PostGroupWorker())
}

// MARK: EDIT TODO SCENE
extension EditToDoSceneBuilder.Dependency {
  @MainActor
  static let live = EditToDoSceneBuilder.Dependency.init(editToDoWorker: EditToDoWorker(httpClient: HTTPClient.live))
}

// MARK: SIGN UP SCENE
extension SignUpSceneBuilder.Dependency {
  @MainActor
  static let live = SignUpSceneBuilder.Dependency.init(signUpWorker: SignUpWorker(httpClient: HTTPClient.live))
}
