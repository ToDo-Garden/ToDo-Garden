import UIKit

import TimerSceneApi
import TimerSceneEntity
import ToDoGardenUIComponent

protocol TimerSceneDisplayLogic: AnyObject {
  func displaySomething(viewModel: TimerScene.Something.ViewModel)
}

public final class TimerSceneViewController: UIViewController, TimerSceneViewControllable {
  private var circularProgressView: CircularProgressView!
  private var targetLabel: UILabel!
  private var timeLabel: UILabel!
  private var controlButton: UIButton!
  
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
    build()
  }
  
  private func build() {
    let vStack = UIStackView()
    vStack.axis = .vertical
    vStack.addSpacing(94)
    
    circularProgressView = buildCircularProgressView()
    layoutCircularProgressView(vStack)
    vStack.addSpacing(55)
    
    targetLabel = buildTargetLabel()
    vStack.addArrangedSubview(targetLabel)
    vStack.addSpacing(9)
    
    timeLabel = buildTimeLabel()
    vStack.addArrangedSubview(timeLabel)
    vStack.addSpacing(21)
    
    controlButton = buildSetTimerButton()
    vStack.addArrangedSubview(controlButton)
    
    vStack.addSpacing()
    view.addSubview(vStack)
    vStack.equalToParent()
  }
  
  private func buildCircularProgressView() -> CircularProgressView {
    let alarm = CircularProgressView(
      progressColor: .toDoGardenRed,
      backgroundColor: .toDoGardenPink,
      lineWidth: 9
    )
    
    return alarm
  }
  
  private func layoutCircularProgressView(_ container: UIStackView) {
    let stack = UIStackView(
      arrangedSubviews: [
        UIView(),
        circularProgressView,
        UIView()
      ]
    )
    stack.distribution = .equalSpacing
    circularProgressView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    circularProgressView.widthAnchor.constraint(equalToConstant: 236).isActive = true
    circularProgressView.heightAnchor.constraint(equalToConstant: 236).isActive = true
    circularProgressView.startAnimation(duration: 3, from: 0, to: 1)
    container.addArrangedSubview(stack)
  }
  
  private func buildTargetLabel() -> UILabel {
    let label = UILabel()
    label.text = "집중시간 40분"
    return label
  }
  
  private func buildTimeLabel() -> UILabel {
    let timeLabel = UILabel()
    timeLabel.text = "08:26"
    return timeLabel
  }
  
  private func buildSetTimerButton() -> UIButton {
    let button = UIButton()
    button.applyRingToggleButtonStyle()
    return button
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

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let viewController = TimerSceneViewController()
  
  return viewController
}
#endif
