// swiftlint:disable xctfail_message

@testable import TimerScene
import XCTest

@MainActor
final class TimerSceneTests: XCTestCase {
  func testSetTimer() async throws {
    let exp = expectation(description: "SetTimer")
    let mock = MockWorker { seconds in
      XCTAssertEqual(seconds, 3)
      return .init { con in
        exp.fulfill()
        con.finish()
      }
    }
    let interactor = TimerSceneInteractor(worker: mock)
    interactor.setTimer(for: 3)
    XCTAssertEqual(interactor.isCountingDown, true)
    await fulfillment(of: [exp])
    XCTAssertEqual(interactor.alertStatus, .welldone)
  }
  
  func testCancelCountDownStreamWithStopConcentration() throws {
    let mock = MockWorker { seconds in
      XCTAssertEqual(seconds, 3)
      return .init {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        XCTFail()
        return 0
      }
    }
    let interactor = TimerSceneInteractor(worker: mock)
    interactor.setTimer(for: 3)
    interactor.sendAlertAction(.stopConcentration)
    XCTAssert(interactor.alertStatus == nil)
  }
  
  func testCancelCountDownStreamWithKeepConcentration() throws {
    let mock = MockWorker { seconds in
      XCTAssertEqual(seconds, 3)
      return .init {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        XCTFail()
        return 0
      }
    }
    let interactor = TimerSceneInteractor(worker: mock)
    interactor.setTimer(for: 3)
    interactor.sendAlertAction(.keepConcentration)
    XCTAssert(interactor.bottomSheetStatus == .focus)
  }
}

struct MockWorker: TimerSceneWorkable {
  var countDownStream: @Sendable (Double) -> AsyncThrowingStream<Double, any Error>
}
// swiftlint:enable xctfail_message
