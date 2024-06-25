import UIKit

import TimerSceneApi
import TimerSceneEntity
import ToDoGardenUIComponent

@MainActor
protocol TimerSceneDisplayLogic: AnyObject {
  func updateTimeLabel(time: Double, isFirst: Bool)
  func displaySomething(viewModel: TimerScene.Something.ViewModel)
}

public final class TimerSceneViewController: UIViewController, TimerSceneViewControllable {
  private var circularProgressView: CircularProgressView!
  private var circularProgressImageView: UIImageView!
  
  private var targetLabel: RemainingTimeView!
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
    build()
    layoutStack()
  }
  
  private func build() {
    circularProgressView = CircularProgressView(
      progressColor: .toDoGardenRed,
      backgroundColor: .toDoGardenLightRed,
      lineWidth: 9
    )
    circularProgressImageView = UIImageView(image: .progressDefault)
    targetLabel = RemainingTimeView()
    targetLabel.updateRemainingTime(with: "집중시간 ")
    timeLabel = buildTimeLabel()
    controlButton = buildSetTimerButton()
  }
  
  private func layoutStack() {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.alignment = .center
    stack.addSpacing(94)
    
    layoutCircularView(stack)
    layoutTargetLabel(stack)
    
    stack.addArrangedSubViewWithSpacing(timeLabel, spacing: 21)
    
    controlButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
    controlButton.widthAnchor.constraint(equalToConstant: 131).isActive = true
    stack.addArrangedSubViewWithSpacing(controlButton)
    
    view.addSubview(stack)
    stack.equalToParent()
  }

  private func buildTimeLabel() -> UILabel {
    let label = UILabel()
    label.font = .pretendardHeadLight75
    label.textColor = .toDoGardenGreenDark
    label.text = "00:00"
    return label
  }
  
  private func buildSetTimerButton() -> UIButton {
    let button = UIButton()
    button.timerControlButtonDefaultStyle(with: "집중시간 설정")
    let action = UIAction { [weak self] _ in
      
    }
    button.addAction(action, for: .touchUpInside)
    return button
  }
  
  private func layoutCircularView(_ stack: UIStackView) {
    circularProgressView.widthAnchor.constraint(equalToConstant: 236).isActive = true
    circularProgressView.heightAnchor.constraint(equalToConstant: 236).isActive = true
    stack.addArrangedSubViewWithSpacing(circularProgressView, spacing: 55)
    
    circularProgressView.addSubview(circularProgressImageView)
    circularProgressImageView.usingAutolayout()
    NSLayoutConstraint.activate([
      circularProgressImageView.topAnchor.constraint(equalTo: circularProgressView.topAnchor, constant: 16),
      circularProgressImageView.bottomAnchor.constraint(equalTo: circularProgressView.bottomAnchor, constant: -16),
      circularProgressImageView.leadingAnchor.constraint(equalTo: circularProgressView.leadingAnchor, constant: 16),
      circularProgressImageView.trailingAnchor.constraint(equalTo: circularProgressView.trailingAnchor, constant: -16)
    ])
  }
  
  private func layoutTargetLabel(_ stack: UIStackView) {
    targetLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    targetLabel.heightAnchor.constraint(equalToConstant: 31).isActive = true
    targetLabel.updateBackgroundColorForFoucsTime()
    stack.addArrangedSubViewWithSpacing(targetLabel, spacing: 9)
  }
}

// MARK: - Confirm display logic protocol
extension TimerSceneViewController: TimerSceneDisplayLogic {
  func updateTimeLabel(time: Double, isFirst: Bool) {
    if isFirst {
      print(time)
      circularProgressView.startAnimation(duration: time, from: 0, to: 1)
    }
    timeLabel.text = String(time)
  }
  
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
  TimerSceneSceneBuilder(dependency: .live)
    .build()
}
#endif
