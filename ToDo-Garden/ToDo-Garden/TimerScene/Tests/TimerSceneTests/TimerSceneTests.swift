// swiftlint:disable line_length
// swiftlint:disable xctfail_message identifier_name  function_body_length opening_brace unused_closure_parameter type_name
@testable import TimerScene
@testable import TimerSceneEntity
import XCTest

@MainActor
final class TimerSceneTests: XCTestCase {
  /// A - 1
  func testControlButtonTappedShowBottomSheet() throws {
    let mock = MockWorker { _ in
      .init { $0.finish() }
    }
    let interactor = TimerSceneInteractor(worker: mock)
    let presenter = MockPresenter(
      presentBottomSheet: { XCTAssert($0 == .focus) }
    )
    interactor.presenter = presenter
    interactor.controlButtonTapped()
  }
  
  /// A - 2
  func testControlButtonTappedShowAlert() throws {
    let mock = MockWorker { _ in
      XCTFail()
      return .init { $0.finish() }
    }
    let interactor = TimerSceneInteractor(worker: mock)
    let presenter = MockPresenter(
      showAlert: { XCTAssert($0 == .stopConcentration) }
    )
    interactor.presenter = presenter
    interactor.isCountingDown = true
    interactor.controlButtonTapped()
  }
  
  /// B - 1
  func testSetTimerHappyCase() async throws {
    let exp = expectation(description: "worker")
    let exp2 = expectation(description: "configureTimerSettings")
    let exp3 = expectation(description: "updateTimeState")
    let exp4 = expectation(description: "showAlert")
    let exp5 = expectation(description: "clearPresentState")
    
    let mock = MockWorker { seconds in
      XCTAssertEqual(seconds, 3)
      return .init { con in
        exp.fulfill()
        con.yield(0)
        con.finish()
      }
    }
    let mockPresenter = MockPresenter(
      configureTimerSettings: { _, _ in
        exp2.fulfill()
      },
      updateTimeState: { _, _ in
        exp3.fulfill()
      },
      showAlert: { _ in
        exp4.fulfill()
      },
      clearPresentState: {
        exp5.fulfill()
      }
    )
    let interactor = TimerSceneInteractor(worker: mock)
    interactor.presenter = mockPresenter
    
    interactor.setTimer(for: 3)
    XCTAssertEqual(interactor.isCountingDown, true)
    await fulfillment(of: [exp, exp2, exp3, exp4, exp5])
    XCTAssertEqual(interactor.isCountingDown, false)
    XCTAssertEqual(interactor.alertStatus, .welldone)
  }
  
  /// B - 2
  func testSetTimerStopCaseWithStopConcentration() async throws {
    let exp = expectation(description: "work")
    let exp2 = expectation(description: "updateViewState")
    let exp3 = expectation(description: "configureTimerSettings")
    let exp4 = expectation(description: "showAlert")
    
    let mock = MockWorker { seconds in
      XCTAssertEqual(seconds, 3)
      exp.fulfill()
      return .init {
        try? await Task.sleep(nanoseconds: 100_000_000)
        XCTFail()
        return nil
      }
    }
    let mockPresenter = MockPresenter(
      updateViewState: { _ in
        exp2.fulfill()
      },
      configureTimerSettings: { _, _ in
        exp3.fulfill()
      },
      showAlert: { _ in
        exp4.fulfill()
      }
    )
    let interactor = TimerSceneInteractor(worker: mock)
    interactor.presenter = mockPresenter
    interactor.setTimer(for: 3)
    interactor.controlButtonTapped()
    XCTAssert(interactor.isCountingDown)
    XCTAssert(interactor.alertStatus == .stopConcentration)
    interactor.sendAlertAction(.stopConcentration)
    XCTAssert(interactor.alertStatus == nil)
    XCTAssert(interactor.tasks.isEmpty)
    await fulfillment(of: [exp, exp2, exp3, exp4])
  }
  
  /// C - 1
  func testSendAlertActionWithStopConcentrationAndStateWellDone() async throws {
    let exp = expectation(description: "work")
    
    let mock = MockWorker { seconds in
      XCTFail()
      return .init { $0.finish() }
    }
    let mockPresenter = MockPresenter(
      updateViewState: {
        XCTAssert($0)
        exp.fulfill()
      }
    )
    let interactor = TimerSceneInteractor(worker: mock)
    interactor.presenter = mockPresenter
    interactor.alertStatus = .welldone
    interactor.sendAlertAction(.stopConcentration)
    XCTAssert(interactor.bottomSheetStatus == .rest)
    await fulfillment(of: [exp])
  }
  
  /// C - 2
  func testSendAlertActionKeepConcentration() async throws {
    let exp = expectation(description: "updateViewState")
    let exp2 = expectation(description: "presentBottomSheet")
    
    let mock = MockWorker { seconds in
      XCTFail()
      return .init { $0.finish() }
    }
    let mockPresenter = MockPresenter(
      updateViewState: {
        XCTAssert(!$0)
        exp.fulfill()
      },
      presentBottomSheet: {
        XCTAssert($0 == .focus)
        exp2.fulfill()
      }
    )
    let interactor = TimerSceneInteractor(worker: mock)
    interactor.presenter = mockPresenter
    interactor.sendAlertAction(.keepConcentration)
    XCTAssert(interactor.bottomSheetStatus == .focus)
    await fulfillment(of: [exp, exp2])
  }
  
  /// C - 3
  func testSendAlertActionGoHome() async throws {
    let exp = expectation(description: "Dismiss")
    let mock = MockWorker { _ in
      XCTFail()
      return .init { $0.finish() }
    }
    let interactor = TimerSceneInteractor(worker: mock)
    let presenter = MockPresenter(dismiss: { exp.fulfill() })
    interactor.presenter = presenter
    
    interactor.sendAlertAction(.goHome)
    await fulfillment(of: [exp])
  }
}

struct MockWorker: TimerSceneWorkable {
  var countDownStream: @Sendable (Double) -> AsyncThrowingStream<Double, any Error>
}

extension MockWorker {
  enum _Error: Error {
    case testError
  }
}

struct MockPresenter: TimerScenePresentationLogic {
  var _updateViewState: ((_ isResting: Bool) -> Void)?
  var _configureTimerSettings: ((_ status: TimerSceneEntity.TimerScene.BottomSheetStatus, _ targetTime: Double) -> Void)?
  var _updateTimeState: ((_ seconds: Double, _ range: TimerSceneEntity.TimerScene.CircularProgressRange) -> Void)?
  var _showAlert: ((_ status: TimerSceneEntity.TimerScene.TimerAlertStatus) -> Void)?
  var _presentBottomSheet: ((_ status: TimerSceneEntity.TimerScene.BottomSheetStatus) -> Void)?
  var _clearPresentState: (() -> Void)?
  var _dismiss: (() -> Void)?
  
  init(
    updateViewState: ((_: Bool) -> Void)? = { _ in XCTFail() },
    configureTimerSettings: ((_: TimerSceneEntity.TimerScene.BottomSheetStatus, _: Double) -> Void)? =  { _, _ in XCTFail("configureTimerSettings") },
    updateTimeState: ((_: Double, _: TimerSceneEntity.TimerScene.CircularProgressRange) -> Void)? = { _, _ in XCTFail("updateTimeState") },
    showAlert: ((_: TimerSceneEntity.TimerScene.TimerAlertStatus) -> Void)? = { _ in XCTFail("showAlert") },
    presentBottomSheet: ((_: TimerSceneEntity.TimerScene.BottomSheetStatus) -> Void)? = { _ in XCTFail("presentBottomSheet") },
    clearPresentState: (() -> Void)? = { XCTFail("clearPresentState") },
    dismiss: (() -> Void)? = { XCTFail("dismiss") }
  ) {
    self._updateViewState = updateViewState
    self._configureTimerSettings = configureTimerSettings
    self._updateTimeState = updateTimeState
    self._showAlert = showAlert
    self._presentBottomSheet = presentBottomSheet
    self._clearPresentState = clearPresentState
    self._dismiss = dismiss
  }
  
  func updateViewState(isResting: Bool) {
    _updateViewState?(isResting)
  }
  
  func configureTimerSettings(_ status: TimerSceneEntity.TimerScene.BottomSheetStatus, for targetTime: Double) {
    _configureTimerSettings?(status, targetTime)
  }
  
  func updateTimeState(_ seconds: Double, range: TimerSceneEntity.TimerScene.CircularProgressRange) {
    _updateTimeState?(seconds, range)
  }
  
  func showAlert(_ status: TimerSceneEntity.TimerScene.TimerAlertStatus) {
    _showAlert?(status)
  }
  
  func presentBottomSheet(_ status: TimerSceneEntity.TimerScene.BottomSheetStatus) {
    _presentBottomSheet?(status)
  }
  
  func clearPresentState() {
    _clearPresentState?()
  }
  
  func dismiss() {
    _dismiss?()
  }
}
// swiftlint:enable xctfail_message identifier_name line_length function_body_length opening_brace unused_closure_parameter type_name
