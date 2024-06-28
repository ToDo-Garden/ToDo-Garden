import UIKit

import TimerSceneApi
import TimerSceneEntity
import ToDoGardenUIComponent

@MainActor
protocol TimerSceneDisplayLogic: AnyObject {
  func updateTargetLabel(time: String)
  func updateControlButton(isFocused: Bool)
  func updateTimeLabel(duration: Double, time: String, isFirst: Bool)
  func updateProgressImage(_ image: UIImage)
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
    self.build()
    self.layoutStack()
  }
  
  private func build() {
    self.circularProgressView = CircularProgressView(
      progressColor: UIColor.toDoGardenRed,
      backgroundColor: UIColor.toDoGardenLightRed,
      lineWidth: 9
    )
    self.circularProgressImageView = UIImageView(image: .progressDefault)
    self.targetLabel = RemainingTimeView()
    self.targetLabel.updateRemainingTime(with: "집중시간")
    self.timeLabel = self.buildTimeLabel()
    self.controlButton = self.buildSetTimerButton()
  }
  
  private func layoutStack() {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.alignment = .center
    stack.addSpacing(94)
    
    self.layoutCircularView(stack)
    self.layoutTargetLabel(stack)
    
    stack.addArrangedSubViewWithSpacing(self.timeLabel, spacing: 21)
    
    self.controlButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
    self.controlButton.widthAnchor.constraint(equalToConstant: 131).isActive = true
    stack.addArrangedSubViewWithSpacing(self.controlButton)
    
    view.addSubview(stack)
    stack.equalToParent()
  }
  
  private func buildTimeLabel() -> UILabel {
    let label = UILabel()
    label.font = UIFont.pretendardHeadLight75
    label.textColor = UIColor.toDoGardenGreenDark
    label.text = "00:00"
    return label
  }
  
  private func buildSetTimerButton() -> UIButton {
    let button = UIButton()
    button.timerControlButtonDefaultStyle(with: "집중시간 설정")
    button.feedbackAnimation(0.98, duration: 0.15)
    let action = UIAction { [weak self] _ in
      self?.interactor?.controlButtonTapped()
    }
    button.addAction(action, for: .touchUpInside)
    return button
  }
  
  private func layoutCircularView(_ stack: UIStackView) {
    self.circularProgressView.widthAnchor.constraint(equalToConstant: 236).isActive = true
    self.circularProgressView.heightAnchor.constraint(equalToConstant: 236).isActive = true
    stack.addArrangedSubViewWithSpacing(self.circularProgressView, spacing: 55)
    
    self.circularProgressView.addSubview(self.circularProgressImageView)
    self.circularProgressImageView.usingAutolayout()
    NSLayoutConstraint.activate([
      self.circularProgressImageView.topAnchor
        .constraint(equalTo: self.circularProgressView.topAnchor, constant: 16),
      self.circularProgressImageView.bottomAnchor
        .constraint(equalTo: self.circularProgressView.bottomAnchor, constant: -16),
      self.circularProgressImageView.leadingAnchor
        .constraint(equalTo: self.circularProgressView.leadingAnchor, constant: 16),
      self.circularProgressImageView.trailingAnchor
        .constraint(equalTo: self.circularProgressView.trailingAnchor, constant: -16)
    ])
  }
  
  private func layoutTargetLabel(_ stack: UIStackView) {
    self.targetLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    self.targetLabel.heightAnchor.constraint(equalToConstant: 31).isActive = true
    self.targetLabel.updateBackgroundColorForFoucsTime()
    stack.addArrangedSubViewWithSpacing(self.targetLabel, spacing: 9)
  }
}

// MARK: - Confirm display logic protocol
extension TimerSceneViewController: TimerSceneDisplayLogic {
  func updateTargetLabel(time: String) {
    self.targetLabel.updateRemainingTime(with: "집중시간 \(time)분")
  }
  
  func updateControlButton(isFocused: Bool) {
    if isFocused {
      self.controlButton.timerControlButtonDestructiveStyle(with: "포기할래요")
    } else {
      self.controlButton.timerControlButtonDefaultStyle(with: "집중시간 설정")
    }
  }
  
  func updateTimeLabel(duration: Double, time: String, isFirst: Bool) {
    if !self.circularProgressView.isAnimating, isFirst {
      self.circularProgressView
        .startAnimation(duration: duration, from: 0, to: 1)
    }
    self.timeLabel.text = time
  }
  
  func updateProgressImage(_ image: UIImage) {
    guard self.circularProgressImageView.image != image else { return }
    self.circularProgressImageView.setImageWithZoomTransition(newImage: image)
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  TimerSceneSceneBuilder(dependency: .live)
    .build()
}
#endif

extension UIImageView {
  func setImageWithZoomTransition(newImage: UIImage?, duration: TimeInterval = 0.3) {
    UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve) {
      self.image = newImage
      self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
    } completion: { _ in
      UIView.animate(withDuration: duration) {
        self.transform = .identity
      }
    }
  }
}
