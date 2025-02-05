import Foundation

import TimerSceneAPI

@MainActor
public struct TimerSceneSceneBuilder {
  /// 컴파일 타임에 필요한 의존성을 선언한 구조체입니다.
  public struct Dependency {
    let timerWorker: TimerSceneWorkable
    let storageWorker: TimerStorageWorkable
    
    public init(
      timerWorker: any TimerSceneWorkable,
      storageWorker: any TimerStorageWorkable
    ) {
      self.timerWorker = timerWorker
      self.storageWorker = storageWorker
    }
  }
  
  private let dependency: Dependency
  
  public init(dependency: Dependency) {
    self.dependency = dependency
  }
}

extension TimerSceneSceneBuilder: TimerSceneSceneBuildable {
  ///  VIP Cycle, 런타임 의존성이 설정된 ViewController 인스턴스를 반환하는 함수입니다.
  /// - Parameter payload: 런타임에 전달받아야 하는 의존성입니다.
  /// - Returns: 런타임 의존성, VIP Cycle이 설정된 ViewController를 반환합니다.
  public func build() -> TimerSceneViewControllable {
    return self.configureVIPCycle(for: TimerSceneViewController())
  }
}

extension TimerSceneSceneBuilder {
  /// VIP Cycle을 설정합니다.
  /// - Parameter viewController: VIPCycle을 설정할 viewController입니다.
  /// - Returns: VIP Cycle 설정이 완료된 `ViewControllable` 프로토콜을 준수한 `ViewController` 인스턴스를 반환합니다.
  private func configureVIPCycle(for viewController: TimerSceneViewController) -> TimerSceneViewController {
    let interactor = TimerSceneInteractor(
      timerWorker: self.dependency.timerWorker,
      storageWorker: self.dependency.storageWorker
    )
    let presenter = TimerScenePresenter()
    viewController.interactor = interactor
    interactor.presenter = presenter
    presenter.viewController = viewController
    
    return viewController
  }
}
