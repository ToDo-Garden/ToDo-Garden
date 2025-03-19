import UIKit

import TDFoundation
import TDUtility
import TimerSceneAPI
import TimerSceneEntity
import ToDoGardenUIAPI
import ToDoGardenUIComponent
import ToDoGardenUIConstant

@MainActor
protocol TimerSceneDisplayLogic: AnyObject {
  func updateDefaultState()
  func updateRestingState()
  func updateProgressImage(_ image: UIImage)
  func updateTargetLabel(time: String)
  func updateTimeLabel(duration: Double, time: String, isFirst: Bool)
  func updateControllerButton(isConcentrating: Bool)

  func showAlert(_ configuration: ToDoGardenAlertView.Configuration)
  func presentBottomSheet(_ configuration: SettingTimeView.Configuration)
  func clearPresentState()
  func dismiss()
}

public final class TimerSceneViewController: UIViewController, TimerSceneViewControllable {
  private var timerProgressView: TimerProgressView!
  private var circularProgressImageView: UIImageView!
  
  private var targetLabel: RemainingTimeView!
  private var timeLabel: UILabel!
  private var controlButton: UIButton!
  
  // MARK: - VIP Properties
  var interactor: TimerSceneBusinessLogic?
  
  // MARK: - Object lifecycle
  public init() {
    super.init(nibName: nil, bundle: nil)
    self.registerBackgroundTransitionObserver()
  }
  
  deinit {
    self.unregisterBackgroundTransition()
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
  
  public override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    self.navigationController?.navigationBar.isHidden = false
  }
  
  public override func viewWillDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.interactor?.requestPOST()
  }

  private func build() {
    self.view.backgroundColor = UIColor.toDoGardenWhite
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
    stack.usingAutolayout()
    self.view.addSubview(stack)
    
    NSLayoutConstraint.activate([
      stack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      stack.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
    ])
    
    self.layoutCircularView(stack)
    self.layoutTargetLabel(stack)
    
    stack.addArrangedSubViewWithSpacing(self.timeLabel, spacing: Constant.Layout.TimeLabel.bottomPadding)
    
    self.controlButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
    self.controlButton.widthAnchor.constraint(equalToConstant: Constant.Layout.ControlButton.width).isActive = true
    stack.addArrangedSubViewWithSpacing(self.controlButton)
  }
  
  private func buildTimeLabel() -> UILabel {
    let label = UILabel()
    label.font = UIFont.pretendardHeadLight75
    label.textColor = UIColor.toDoGardenGreenDark
    label.text = Constant.TimeLabel.defaultText
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
      self?.interactor?.controlButtonTapped()
    }
    button.addAction(action, for: .touchUpInside)
    return button
  }
  
  private func layoutCircularView(_ stack: UIStackView) {
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
  // MARK: - View Update
  func updateDefaultState() {
    self.timerProgressView.resetProgress()
    self.timerProgressView.setColors(
      to: TimerProgressView.TimerProgressViewColors(
        progress: UIColor.toDoGardenRed,
        background: UIColor.toDoGardenLightRed,
        dot: UIColor.toDoGardenRed
      )
    )
    self.view.backgroundColor = UIColor.toDoGardenWhite
    self.targetLabel.updateRemainingTime(with: Constant.DefaultViewState.targetLabel)
    self.targetLabel.updateBackgroundColorForFoucsTime()
    self.timeLabel.text = Constant.TimeLabel.defaultText
    self.controlButton.timerControlButtonDefaultStyle(with: Constant.DefaultViewState.setTimerButton)
  }
  
  func updateRestingState() {
    self.timerProgressView.resetProgress()
    self.timerProgressView.setColors(
      to: TimerProgressView.TimerProgressViewColors(
        progress: UIColor.toDoGardenGreenDark,
        background: UIColor.toDoGardenLeaf,
        dot: UIColor.toDoGardenGreenDark
      )
    )
    self.view.backgroundColor = UIColor.toDoGardenGreenBackground
    self.targetLabel.updateRemainingTime(with: Constant.RestingViewState.targetLabel)
    self.targetLabel.updateBackgroundColorForBreakTime()
    self.timeLabel.text = Constant.TimeLabel.defaultText
    self.controlButton.timerControlButtonDefaultStyle(with: Constant.RestingViewState.setTimerButton)
  }
  
  func updateProgressImage(_ image: UIImage) {
    guard self.circularProgressImageView.image != image else { return }
    self.circularProgressImageView.setImageWithZoomTransition(newImage: image)
  }
  
  func updateTargetLabel(time: String) {
    self.targetLabel.updateRemainingTime(with: Constant.TargetLabel.updated(time))
  }
  
  func updateTimeLabel(duration: Double, time: String, isFirst: Bool) {
    if !timerProgressView.isAnimating, isFirst {
      self.timerProgressView
        .startAnimation(duration: duration, to: 1)
    }
    self.timeLabel.text = time
  }
  
  func updateControllerButton(isConcentrating: Bool) {
    if isConcentrating {
      self.controlButton
        .timerControlButtonDestructiveStyle(with: Constant.DefaultViewState.setTimerIsSelected)
    } else {
      self.controlButton
        .timerControlButtonDefaultStyle(with: Constant.RestingViewState.setTimerIsSelected)
    }
  }
  
  // MARK: - ViewController Transition
  func showAlert(_ configuration: ToDoGardenAlertView.Configuration) {
    let alert = ToDoGardenAlertController(for: configuration)
    alert.delegate = self
    self.showAlert(alert)
  }
  
  func presentBottomSheet(_ configuration: SettingTimeView.Configuration) {
    let bottomSheet = FocusTimeSettings(configuration: configuration)
    bottomSheet.completion = { [weak self] in
      self?.interactor?.setTimer(for: $0)
    }
    bottomSheet.sheetPresentationController?.detents = [.medium()]
    self.present(bottomSheet, animated: true)
  }
  
  func clearPresentState() {
    if self.presentedViewController is ToDoGardenAlertController {
      self.closeAlert()
    } else if let bottomSheet = presentedViewController as? FocusTimeSettings {
      bottomSheet.dismiss(animated: true)
    }
  }
  
  func dismiss() {
    self.closeAlert { [weak self] in
      self?.dismiss(animated: true)
    }
  }
}

extension TimerSceneViewController: ToDoGardenAlertControllerDelegate {
  public func handleButtonAction(
    _ buttonType: ToDoGardenUIConstant.Constant.ToDoGardenAlertView.Content.ButtonActionType
  ) {
    self.closeAlert()
    self.interactor?.sendAlertAction(self.convertAction(buttonType))
  }
  
  private func convertAction(
    _ actionType: ToDoGardenUIConstant.Constant.ToDoGardenAlertView.Content.ButtonActionType
  ) -> TimerScene.AlertAction {
    if actionType == .cancel {
      return .cancel
    } else if actionType == .keepConcentration {
      return .keepConcentration
    } else if actionType == .goHome {
      return .goHome
    } else if actionType == .stopConcentration {
      return .stopConcentration
    } else {
      fatalError("호출되면 안됩니다.")
    }
  }
}

extension TimerSceneViewController {
  private final class FocusTimeSettings: UIViewController {
    let configuration: SettingTimeView.Configuration
    var completion: ((Double) -> Void)?
    
    init(configuration: SettingTimeView.Configuration) {
      self.configuration = configuration
      super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
      self.view.backgroundColor = UIColor.toDoGardenWhite
      let stack = UIStackView()
      stack.axis = .vertical
      let button = self.buildButton()
      let settingTimeView = SettingTimeView(with: button, for: configuration)
      let action = self.buildButtonAction(settingTimeView)
      button.addAction(action, for: .touchUpInside)
      
      stack.addArrangedSubview(settingTimeView)
      self.view.addSubview(stack)
      stack.equalToParent()
    }
    
    private func buildButton() -> UIButton {
      let button = UIButton()
      button.timerControlButtonDefaultStyle(with: "시작하기")
      let width = TimerSceneViewController.Constant.Layout.ControlButton.width
      button.widthAnchor.constraint(equalToConstant: width).isActive = true
      return button
    }
    
    private func buildButtonAction(_ settingTimeView: SettingTimeView) -> UIAction {
      return UIAction { [weak self, weak settingTimeView]_ in
        guard let seconds = settingTimeView?.seconds else { return }
        self?.completion?(seconds)
        // TODO: - 화면을 제거하는 로직은 외부에서 처리하는게 더 적합합니다.
        self?.dismiss(animated: true)
      }
    }
  }
}

extension TimerSceneViewController {
  func setPayload(_ payload: TimerScenePayloadable?) {
    guard let payload = payload else { return }
    
    self.title = payload.groupName
    self.interactor?.setCurrentGroup(payload)
  }
}

extension TimerSceneViewController: @preconcurrency TransitionHandlable {
  public func handleBackgroundTransition() {
    self.interactor?.requestPOST()
  }
}

#if DEBUG
import HTTPClient
@available(iOS 17.0, *)
#Preview {
  /// Navigation Title Not Displaying Correctly
  let timerWorker = TimerSceneWorker.live
  let storageWorker = TimerStorageWorker(
    httpClient: HTTPClient(
      transport: URLSessionTransport(
        urlSession: URLSession.shared
      ),
      middlewares: []
    ),
    timerStorage: TimerStorage.live
  )
  let viewController = TimerSceneBuilder(
    dependency: .init(
      timerWorker: timerWorker,
      storageWorker: storageWorker,
      notificationManager: NotificationManager.shared,
      networkRetryManager: NetworkRetryManager()
    )
  ).build(with: nil)
  
  let navigation = UINavigationController(rootViewController: viewController)
  navigation
}
#endif
