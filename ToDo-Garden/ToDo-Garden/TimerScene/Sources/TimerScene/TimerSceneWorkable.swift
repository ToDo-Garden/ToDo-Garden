import Foundation

@MainActor
public protocol TimerSceneWorkable: Sendable {
  var countDownStream: @Sendable (Double) -> AsyncStream<Double> { get set }
}

public protocol TimerStorageWorkable: Sendable {
  
}
