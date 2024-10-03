//
//  ToDoCheckBoxButton.swift
//
//
//  Created by Wood on 5/2/24.
//

import UIKit

import ToDoGardenUIAPI
import ToDoGardenUIConstant
import ToDoGardenUIResource

public final class ToDoCheckBoxButton: UIButton, HapticFeedbackable {
  private var checkmarkDrawingLayer: CAShapeLayer

  public init() {
    self.checkmarkDrawingLayer = CAShapeLayer()
    super.init(frame: CGRect.zero)
    self.setup()
  }

  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Private Functions

extension ToDoCheckBoxButton {
  private func setup() {
    self.setupAction()
    self.setupToDoCompleteAnimation()
    self.setupUI()
  }

  private func completeToDo() {
    self.isSelected = true
    self.triggerHapticFeedback(
      type: HapticFeedbackType.impact(
        style: UIImpactFeedbackGenerator.FeedbackStyle.heavy
      )
    )
    self.drawCompleteToDoAnimation()
  }

  private func resetToDo() {
    self.isSelected = false
    self.backgroundColor = UIColor.toDoGardenWhite
  }
}

// MARK: Set Up Action

extension ToDoCheckBoxButton {
  private func setupAction() {
    self.addAction(
      self.makeButtonAction(),
      for: UIControl.Event.touchUpInside
    )
  }

  private func makeButtonAction() -> UIAction {
    return UIAction { [weak self] _ in
      guard let self else { return }
      if self.isSelected {
        self.resetToDo()
      } else {
        self.completeToDo()
      }
    }
  }
}

// MARK: Set up Animation

extension ToDoCheckBoxButton {
  private func setupToDoCompleteAnimation() {
    self.setupAnimationUI()
    self.setupAnimationPath()
  }

  private func drawCompleteToDoAnimation() {
    let animation = CABasicAnimation(keyPath: Constant.ToDoCheckBoxButton.Animation.keyPath)
    animation.duration = Constant.ToDoCheckBoxButton.Animation.duration
    animation.fromValue = Constant.ToDoCheckBoxButton.Animation.fromValue
    animation.toValue = Constant.ToDoCheckBoxButton.Animation.toValue
    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    self.checkmarkDrawingLayer.add(animation, forKey: nil)
  }

  private func setupAnimationUI() {
    self.checkmarkDrawingLayer.lineWidth = Constant.ToDoCheckBoxButton.Layout.lineWidth
    self.checkmarkDrawingLayer.fillColor = UIColor.clear.cgColor
    self.checkmarkDrawingLayer.strokeColor = UIColor.white.cgColor
    self.checkmarkDrawingLayer.lineCap = CAShapeLayerLineCap.round
    self.checkmarkDrawingLayer.lineJoin = CAShapeLayerLineJoin.round
    self.layer.addSublayer(self.checkmarkDrawingLayer)
  }

  private func setupAnimationPath() {
    let bezierPath = UIBezierPath()
    self.setupStartPoint(to: bezierPath)
    self.setupMiddlePoint(to: bezierPath)
    self.setupEndPoint(to: bezierPath)
    self.checkmarkDrawingLayer.path = bezierPath.cgPath
  }

  private func setupStartPoint(to bezierPath: UIBezierPath) {
    let offsetXToStartPoint = Constant.ToDoCheckBoxButton.Animation.Path.offsetXToStartPoint
    let offsetYToStartPoint = Constant.ToDoCheckBoxButton.Animation.Path.offsetYToStartPoint
    let startPoint = CGPoint(
      x: self.frame.origin.x + offsetXToStartPoint,
      y: self.frame.origin.x + offsetYToStartPoint
    )
    bezierPath.move(to: startPoint)
  }

  private func setupMiddlePoint(to bezierPath: UIBezierPath) {
    let offsetXToMiddlePoint = Constant.ToDoCheckBoxButton.Animation.Path.offsetXToMiddlePoint
    let offsetYToMiddlePoint = Constant.ToDoCheckBoxButton.Animation.Path.offsetYToMiddlePoint
    let middlePoint = CGPoint(
      x: bezierPath.currentPoint.x + offsetXToMiddlePoint,
      y: bezierPath.currentPoint.y + offsetYToMiddlePoint
    )
    bezierPath.addLine(to: middlePoint)
  }

  private func setupEndPoint(to bezierPath: UIBezierPath) {
    let offsetXToEndPoint = Constant.ToDoCheckBoxButton.Animation.Path.offsetXToEndPoint
    let offsetYToEndPoint = Constant.ToDoCheckBoxButton.Animation.Path.offsetYToEndPoint
    let endPoint = CGPoint(
      x: bezierPath.currentPoint.x + offsetXToEndPoint,
      y: bezierPath.currentPoint.y - offsetYToEndPoint
    )
    bezierPath.addLine(to: endPoint)
  }
}

// MARK: set up UI

extension ToDoCheckBoxButton {
  private func setupUI() {
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let button = ToDoCheckBoxButton()
  button.translatesAutoresizingMaskIntoConstraints = false
  button.widthAnchor.constraint(equalToConstant: Constant.ToDoCheckBoxButton.Size.priamry.width).isActive = true
  button.heightAnchor.constraint(equalToConstant: Constant.ToDoCheckBoxButton.Size.priamry.height).isActive = true
  return button
}
#endif
