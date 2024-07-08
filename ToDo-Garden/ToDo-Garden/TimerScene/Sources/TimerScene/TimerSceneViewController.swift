import UIKit

import TimerSceneAPI
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
  private var timerProgressView: TimerProgressView!
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
    self.timerProgressView = TimerProgressView(
      circularProgressView: CircularProgressView(
        progressColor: UIColor.toDoGardenRed,
        backgroundColor: UIColor.toDoGardenLightRed,
        lineWidth: Constant.Layout.TimerProgressView.lineWidth
      ),
      dotColor: UIColor.toDoGardenRed
    )
    self.circularProgressImageView = UIImageView(image: .progressDefault)
    self.targetLabel = RemainingTimeView()
    self.targetLabel.updateRemainingTime(with: Constant.DefaultViewState.targetLabel)
    self.timeLabel = self.buildTimeLabel()
    self.controlButton = self.buildSetTimerButton()
  }
  
  private func layoutStack() {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.alignment = .center
    stack.addSpacing(Constant.Layout.BaseStack.topPadding)
    
    self.layoutCircularView(stack)
    self.layoutTargetLabel(stack)
    
    stack.addArrangedSubViewWithSpacing(self.timeLabel, spacing: Constant.Layout.TimeLabel.bottomPadding)
    
    self.controlButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
    self.controlButton.widthAnchor.constraint(equalToConstant: Constant.Layout.ControlButton.width).isActive = true
    stack.addArrangedSubViewWithSpacing(self.controlButton)
    
    self.view.addSubview(stack)
    stack.equalToParent()
  }
  
  private func buildTimeLabel() -> UILabel {
    let label = UILabel()
    label.font = UIFont.pretendardHeadLight75
    label.textColor = UIColor.toDoGardenGreenDark
    label.text = Constant.DefaultViewState.timeLabel
    return label
  }
  
  private func buildSetTimerButton() -> UIButton {
    let button = UIButton()
    button.timerControlButtonDefaultStyle(with: Constant.DefaultViewState.setTimerButton)
    
    button.feedbackAnimation(
      Constant.Layout.SetTimerButton.animationScale,
      duration: Constant.Layout.SetTimerButton.animationDuration
    )
    let action = UIAction { [weak self] _ in
      let bottom = FocusTimeSettings()
      bottom.completion = {
        self?.interactor?.setTimer(for: $0)
      }
      bottom.sheetPresentationController?.detents = [.medium()]
      self?.present(bottom, animated: true)
    }
    button.addAction(action, for: .touchUpInside)
    return button
  }
  
  private func layoutCircularView(_ stack: UIStackView) {
    self.timerProgressView.widthAnchor
      .constraint(equalToConstant: Constant.Layout.TimerProgressView.width).isActive = true
    self.timerProgressView.heightAnchor
      .constraint(equalToConstant: Constant.Layout.TimerProgressView.height).isActive = true
    stack.addArrangedSubViewWithSpacing(
      self.timerProgressView,
      spacing: Constant.Layout.TimerProgressView.bottomPadding
    )
    
    self.timerProgressView.addSubview(self.circularProgressImageView)
    self.circularProgressImageView.usingAutolayout()
    let padding = Constant.Layout.TimerProgressView.innerPadding
    NSLayoutConstraint.activate([
      self.circularProgressImageView.topAnchor
        .constraint(equalTo: self.timerProgressView.topAnchor, constant: padding),
      self.circularProgressImageView.bottomAnchor
        .constraint(equalTo: self.timerProgressView.bottomAnchor, constant: -padding),
      self.circularProgressImageView.leadingAnchor
        .constraint(equalTo: self.timerProgressView.leadingAnchor, constant: padding),
      self.circularProgressImageView.trailingAnchor
        .constraint(equalTo: self.timerProgressView.trailingAnchor, constant: -padding)
    ])
  }
  
  private func layoutTargetLabel(_ stack: UIStackView) {
    self.targetLabel.widthAnchor
      .constraint(equalToConstant: Constant.Layout.TargetLabel.width).isActive = true
    self.targetLabel.heightAnchor
      .constraint(equalToConstant: Constant.Layout.TargetLabel.height).isActive = true
    self.targetLabel.updateBackgroundColorForFoucsTime()
    stack.addArrangedSubViewWithSpacing(self.targetLabel, spacing: Constant.Layout.TargetLabel.bottomPadding)
  }
}

// MARK: - Confirm display logic protocol
extension TimerSceneViewController: TimerSceneDisplayLogic {
  func updateTargetLabel(time: String) {
    self.targetLabel.updateRemainingTime(with: Constant.TargetLabel.updated(time))
  }
  
  func updateControlButton(isFocused: Bool) {
    if isFocused {
      self.controlButton.timerControlButtonDestructiveStyle(with: Constant.ControlButton.giveUp)
    } else {
      self.controlButton.timerControlButtonDefaultStyle(with: Constant.ControlButton.setFocusTime)
    }
  }
  
  func updateTimeLabel(duration: Double, time: String, isFirst: Bool) {
    if !timerProgressView.isAnimating, isFirst {
      self.timerProgressView
        .startAnimation(duration: duration, to: 1)
    }
    self.timeLabel.text = time
  }
  
  func updateProgressImage(_ image: UIImage) {
    guard self.circularProgressImageView.image != image else { return }
    self.circularProgressImageView.setImageWithZoomTransition(newImage: image)
  }
}

extension TimerSceneViewController {
  private final class FocusTimeSettings: UIViewController {
    var completion: ((Double) -> Void)?
    
    override func viewDidLoad() {
      view.backgroundColor = UIColor.toDoGardenWhite
      let stack = UIStackView()
      stack.axis = .vertical
      let button = self.buildButton()
      let settingTimeView = SettingTimeView(with: button, for: .focusTimeSetting)
      let action = self.builButtonAction(settingTimeView)
      button.addAction(action, for: .touchUpInside)
      
      stack.addArrangedSubview(settingTimeView)
      view.addSubview(stack)
      stack.equalToParent()
    }
    
    private func buildButton() -> UIButton {
      let button = UIButton()
      button.timerControlButtonDefaultStyle(with: "시작하기")
      let width = TimerSceneViewController.Constant.Layout.ControlButton.width
      button.widthAnchor.constraint(equalToConstant: width).isActive = true
      return button
    }
    
    private func builButtonAction(_ settingTimeView: SettingTimeView) -> UIAction {
      return UIAction { [weak self, weak settingTimeView]_ in
        guard let seconds = settingTimeView?.seconds else { return }
        self?.completion?(seconds)
        // TODO: - 화면을 제거하는 로직은 외부에서 처리하는게 더 적합합니다.
        self?.dismiss(animated: true)
      }
    }
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  TimerSceneSceneBuilder(dependency: .live)
    .build()
}
#endif
