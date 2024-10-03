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

  @ExecuteOnce private var setAnimation: (() -> Void)?

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

  public override func draw(_ rect: CGRect) {
    super.draw(rect)
    self.setAnimation = {
      self.setupAnimationPath()
    }
  }
}

// MARK: Set up Animation

extension ToDoCheckBoxButton {
  private func setupAnimationLayerUI() {
    self.checkmarkDrawingLayer.lineWidth = Constant.ToDoCheckBoxButton.Layout.lineWidth
    self.checkmarkDrawingLayer.fillColor = UIColor.clear.cgColor
    self.checkmarkDrawingLayer.strokeColor = UIColor.white.cgColor
    self.checkmarkDrawingLayer.lineCap = CAShapeLayerLineCap.round
    self.checkmarkDrawingLayer.lineJoin = CAShapeLayerLineJoin.round
    self.layer.addSublayer(self.checkmarkDrawingLayer)
  }

  /// 버튼의 크기에 맞게 체크표시 애니메이션의 경로를 설정하는 메서드입니다.
  /// 버튼의 크기를 얻기 위해 draw 메서드에서 호출됩니다.
  private func setupAnimationPath() {
    let bezierPath = UIBezierPath()
    self.setupStartPoint(to: bezierPath)
    self.setupMiddlePoint(to: bezierPath)
    self.setupEndPoint(to: bezierPath)
    self.checkmarkDrawingLayer.path = bezierPath.cgPath
  }

  private func setupStartPoint(to bezierPath: UIBezierPath) {
    let constant = Constant.ToDoCheckBoxButton.Animation.Path.StartPoint.self
    let pointX = self.bounds.origin.x + (self.bounds.width * constant.offsetX)
    let pointY = self.bounds.origin.y + (self.bounds.height * constant.offsetY)
    let startPoint = CGPoint(x: pointX, y: pointY)
    bezierPath.move(to: startPoint)
  }

  private func setupMiddlePoint(to bezierPath: UIBezierPath) {
    let constant = Constant.ToDoCheckBoxButton.Animation.Path.MiddlePoint.self
    let pointX = bezierPath.currentPoint.x + (self.bounds.width * constant.offsetX)
    let pointY = bezierPath.currentPoint.y + (self.bounds.height * constant.offsetY)
    let middlePoint = CGPoint(x: pointX, y: pointY)
    bezierPath.addLine(to: middlePoint)
  }

  private func setupEndPoint(to bezierPath: UIBezierPath) {
    let constant = Constant.ToDoCheckBoxButton.Animation.Path.EndPoint.self
    let pointX = bezierPath.currentPoint.x + (self.bounds.width * constant.offsetX)
    let pointY = bezierPath.currentPoint.y - (self.bounds.height * constant.offsetY)
    let endPoint = CGPoint(x: pointX, y: pointY)
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
