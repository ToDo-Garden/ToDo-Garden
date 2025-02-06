import Foundation

import TimerSceneEntity

@MainActor
public protocol TimerSceneWorkable: Sendable {
  var countDownStream: @Sendable (Double) -> AsyncStream<Double> { get set }
}

public protocol TimerStorageWorkable: Sendable {
  func postCompletedItem() async throws
  func recordCompletedItemInLocal(groupId: String, seconds: Int) throws
  func deleteAllTimerItems() throws
  func getTimerItemsAsDTO() throws -> TimerScene.FocusTimeRequestDTO
}
