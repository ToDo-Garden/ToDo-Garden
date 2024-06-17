import UIKit

import TimerSceneApi
import TimerSceneEntity

protocol TimerSceneDisplayLogic: AnyObject {
  func displaySomething(viewModel: TimerScene.Something.ViewModel)
}

public final class TimerSceneViewController: UIViewController, TimerSceneViewControllable {
  // MARK: - VIP Properties
  var interactor: TimerSceneBusinessLogic?
  var router: (TimerSceneRoutingLogic & TimerSceneDataPassing)?
  
  // MARK: - Object lifecycle
  public init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View lifecycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.doSomething()
  }
}

// MARK: - Confirm display logic protocol
extension TimerSceneViewController: TimerSceneDisplayLogic {
  func displaySomething(viewModel: TimerScene.Something.ViewModel) {
    // self.nameTextField.text = viewModel.name
  }
}

// MARK: - Request to interactor
extension TimerSceneViewController {
  func doSomething() {
    let request = TimerScene.Something.Request()
    self.interactor?.doSomething(request: request)
  }
}
