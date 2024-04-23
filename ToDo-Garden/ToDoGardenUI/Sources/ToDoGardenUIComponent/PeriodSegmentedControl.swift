//
//  PeriodSegmentedControl.swift
//
//
//  Created by SONG on 4/12/24.
//

import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

public final class PeriodSegmentedControl: UIControl {
  private let items: [String]
  private let feedbackGenerator: UISelectionFeedbackGenerator
  private let periodSegmentedControlAppearance: PeriodSegmentedControlAppearance
  private var targetXPositions: [CGFloat]
  private var periodSegmentedControlGestureRecognizer: PeriodSegmentedControlGestureRecognizer?
  private var expectedXPosition: CGFloat
  
  public init(items: [String] = Constant.PeriodSegmentedControl.Content.defaultItems) {
    self.items = items
    self.feedbackGenerator = UISelectionFeedbackGenerator()
    self.targetXPositions = []
    self.periodSegmentedControlAppearance = PeriodSegmentedControlAppearance(with: self.items)
    self.periodSegmentedControlGestureRecognizer = nil
    self.expectedXPosition = Constant.PeriodSegmentedControl.Layout.firstItemCenterXPosition +
    Constant.PeriodSegmentedControl.Layout.itemWidth
    super.init(frame: CGRect.zero)
    self.setup()
  }
  
  required init?(coder: NSCoder) {
    self.items = Constant.PeriodSegmentedControl.Content.defaultItems
    self.feedbackGenerator = UISelectionFeedbackGenerator()
    self.targetXPositions = []
    self.periodSegmentedControlAppearance = PeriodSegmentedControlAppearance(with: self.items)
    self.periodSegmentedControlGestureRecognizer = nil
    self.expectedXPosition = Constant.PeriodSegmentedControl.Layout.firstItemCenterXPosition +
    Constant.PeriodSegmentedControl.Layout.itemWidth
    super.init(coder: coder)
    self.setup()
  }
  
  public override var intrinsicContentSize: CGSize {
    let layoutConstants = Constant.PeriodSegmentedControl.Layout.self
    let itemsWidth = layoutConstants.itemWidth * CGFloat(self.items.count)
    let width = layoutConstants.innerPadding + itemsWidth + layoutConstants.innerPadding
    let height = layoutConstants.height
    return CGSize(width: width, height: height)
  }
  
  override public func draw(_ rect: CGRect) {
    super.draw(rect)
    self.periodSegmentedControlAppearance.moveIndicatorView(
      to: self.periodSegmentedControlAppearance.getIndicatorViewCenter()
    )
  }
  
  public func highlightedIndex() -> Int? {
    let currentX = self.calculateClosestX(from: self.expectedXPosition)
    return currentX.calculateHighlightedIndex()
  }
}

// MARK: - private functions
extension PeriodSegmentedControl {
  private func setup() {
    self.setupTargetXPosition()
    self.setupFeedbackGenerator()
    self.setupAppearanceLayout()
    self.setupGestureRecognizer()
  }
  
  private func setupTargetXPosition() {
    let itemWidth = Constant.PeriodSegmentedControl.Layout.itemWidth
    let firstCenter = Constant.PeriodSegmentedControl.Layout.firstItemCenterXPosition
    var targets: [CGFloat] = []
    
    for index in 0..<self.items.count {
      targets.append(firstCenter + (itemWidth * CGFloat(index)))
    }
    self.targetXPositions = targets
  }
  
  private func setupAppearanceLayout() {
    let appearance = self.periodSegmentedControlAppearance.getAssembledView()
    self.addSubview(appearance)
    
    appearance.usingAutolayout()
    NSLayoutConstraint.activate(
      [
        appearance.widthAnchor.constraint(equalTo: self.widthAnchor),
        appearance.heightAnchor.constraint(equalTo: self.heightAnchor),
        appearance.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        appearance.centerYAnchor.constraint(equalTo: self.centerYAnchor)
      ]
    )
  }
  
  private func setupGestureRecognizer() {
    self.periodSegmentedControlGestureRecognizer = PeriodSegmentedControlGestureRecognizer(
      target: self,
      panAction: #selector(self.panned),
      tapAction: #selector(self.tapped),
      longpressAction: #selector(self.longpressed)
    )
  }
  
  private func calculateClosestX(from touchX: CGFloat) -> CGFloat {
    var closestX = self.targetXPositions[0]
    var shortestDistance = abs(self.targetXPositions[0] - touchX)
    
    for targetX in self.targetXPositions {
      let distance = abs(targetX - touchX)
      if distance < shortestDistance {
        shortestDistance = distance
        closestX = targetX
      }
    }
    return closestX
  }
  
  private func setupFeedbackGenerator() {
    self.feedbackGenerator.prepare()
  }
}

// MARK: - gesture event functions

extension PeriodSegmentedControl {
  private func handleGestureStateBegan() {
    UIView.animate(withDuration: 0.3) {
      self.periodSegmentedControlAppearance.transformIndicatorViewDownScale()
    }
  }
  
  private func handleGestureStateChanged(with recognizer: UIGestureRecognizer) {
    guard let panRecognizer = recognizer as? UIPanGestureRecognizer else { return }
    
    let translation = panRecognizer.translation(in: self)
    let indicatorViewCenterX = self.periodSegmentedControlAppearance.getIndicatorViewCenter()
    let newX = self.expectedXPosition + translation.x
    let closestX = self.calculateClosestX(from: newX)
    
    if indicatorViewCenterX != closestX {
      UIView.animate(withDuration: 0.15) {
        self.periodSegmentedControlAppearance.moveIndicatorView(to: closestX)
      }
      self.feedbackGenerator.selectionChanged()
      self.expectedXPosition = closestX
    }
    
    self.expectedXPosition = newX
    panRecognizer.setTranslation(.zero, in: self)
  }
  
  private func handleGestureStateEnded() {
    UIView.animate(withDuration: 0.3) {
      self.periodSegmentedControlAppearance.transformIndicatorViewOriginalScale()
    }
    self.feedbackGenerator.selectionChanged()
  }
  
  @objc private func panned(_ recognizer: UIPanGestureRecognizer) {
    switch recognizer.state {
    case UIGestureRecognizer.State.began:
      self.handleGestureStateBegan()
    case UIGestureRecognizer.State.changed:
      self.handleGestureStateChanged(with: recognizer)
    case UIGestureRecognizer.State.ended,
      UIGestureRecognizer.State.cancelled,
      UIGestureRecognizer.State.failed:
      self.handleGestureStateEnded()
    default:
      break
    }
  }
  
  @objc private func tapped(_ recognizer: UITapGestureRecognizer) {
    switch recognizer.state {
    case UIGestureRecognizer.State.recognized:
      let touchLocation = recognizer.location(in: self)
      let closestX = self.calculateClosestX(from: touchLocation.x)
      
      UIView.animate(withDuration: 0.15) {
        self.periodSegmentedControlAppearance.moveIndicatorView(to: closestX)
      }
      self.feedbackGenerator.selectionChanged()
      self.expectedXPosition = closestX
    default:
      break
    }
  }
  
  @objc private func longpressed(_ recognizer: UILongPressGestureRecognizer) {
    switch recognizer.state {
    case UIGestureRecognizer.State.began:
      self.handleGestureStateBegan()
      self.feedbackGenerator.selectionChanged()
    case UIGestureRecognizer.State.ended,
      UIGestureRecognizer.State.cancelled,
      UIGestureRecognizer.State.failed:
      self.handleGestureStateEnded()
    default:
      break
    }
  }
}

// MARK: - about UIGestureRecognizerDelegate

extension PeriodSegmentedControl: UIGestureRecognizerDelegate {
  public func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
  ) -> Bool {
    return gestureRecognizer is UIPanGestureRecognizer && otherGestureRecognizer is UILongPressGestureRecognizer
  }
}

// MARK: - for customizing

extension PeriodSegmentedControl {
  public func setBackgroundImage(image: UIImage) {
    self.periodSegmentedControlAppearance.changeBackgroundImage(image)
  }
  
  public func setIndicatorImage(image: UIImage) {
    self.periodSegmentedControlAppearance.changeIndicatorImage(image)
  }
  
  public func setInitialSelectedItem(index: Int) {
    self.periodSegmentedControlAppearance.changeInitialSelectedItem(index: index, numberOfItems: self.items.count)
  }
}

private extension CGFloat {
  func calculateHighlightedIndex() -> Int? {
    let firstItemCenterX = Int(Constant.PeriodSegmentedControl.Layout.firstItemCenterXPosition)
    let itemWidth = Int(Constant.PeriodSegmentedControl.Layout.itemWidth)
    
    return (Int(self) - firstItemCenterX) / itemWidth
  }
}
