//
//  StaticObjects.swift
//  AppCore
//
//  Created by SONG on 2/4/25.
//

import Foundation

import HTTPClient
import ShareGardenScene
import TDFoundation
import TimerScene

extension TimerSceneSceneBuilder.Dependency {
  @MainActor
  public static let live = TimerSceneSceneBuilder.Dependency(
    timerWorker: TimerSceneWorker.live,
    storageWorker: TimerStorageWorker.live,
    notificationManager: NotificationManager.shared,
    networkRetryManager: NetworkRetryManager()
  )
}

extension TimerStorageWorker {
  static let live = TimerStorageWorker(
    httpClient: HTTPClient.live,
    timerStorage: TimerStorage.live
  )
}

extension ShareGardenSceneSceneBuilder.Dependency {
  public static let live = ShareGardenSceneSceneBuilder.Dependency.init(
    shareGardenSceneWorker: ShareGardenSceneWorker.live
  )
}

extension ShareGardenSceneWorker {
  static let live = ShareGardenSceneWorker.init(httpClient: HTTPClient.live)
}
