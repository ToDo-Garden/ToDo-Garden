//
//  ToDoCheckBoxButton.swift
//
//
//  Created by Wood on 5/2/24.
//

import UIKit

import TDUtility
import ToDoGardenUIAPI
import ToDoGardenUIConstant
import ToDoGardenUIResource

public final class ToDoCheckBoxButton: UIButton, HapticFeedbackable {
  private var mainColor: UIColor
  private var checkmarkDrawingLayer: CAShapeLayer
  var isActionBlocked: Bool = false

  @ExecuteOnce private var setAnimation: (() -> Void)?

  public init() {
    self.mainColor = UIColor.toDoGardenGreenDark
    self.checkmarkDrawingLayer = CAShapeLayer()
    super.init(frame: CGRect.zero)
    self.setup()
  }
  
  public init(action: UIAction) {
    self.mainColor = UIColor.toDoGardenGreenDark
    self.checkmarkDrawingLayer = CAShapeLayer()
    super.init(frame: CGRect.zero)
    self.addAction(action, for: UIControl.Event.touchUpInside)
    self.setup()
  }

  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func draw(_ rect: CGRect) {
    super.draw(rect)
    self.setAnimation = {
      self.setupAnimationPath()
    }
  }

  /// 체크박스의 메인 색상을 변경하는 함수입니다.
  /// 메인 색상 변경시, 테두리 색상과 선택되었을 때 배경색이 함께 변경됩니다.
  public func updateMainColor(_ color: UIColor) {
    self.mainColor = color
    self.layer.borderColor = color.cgColor
  }

  public func setSelected() {
    self.backgroundColor = self.mainColor
    self.drawCompleteToDoAnimation()
    self.makeVibration()
  }

  public func setDeSelected() {
    self.backgroundColor = UIColor.toDoGardenWhite
  }
}

// MARK: - Private Functions

extension ToDoCheckBoxButton {
  private func drawCompleteToDoAnimation() {
    let animation = CABasicAnimation(keyPath: Constant.ToDoCheckBoxButton.Animation.keyPath)
    animation.duration = Constant.ToDoCheckBoxButton.Animation.duration
    animation.fromValue = Constant.ToDoCheckBoxButton.Animation.fromValue
    animation.toValue = Constant.ToDoCheckBoxButton.Animation.toValue
    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    self.checkmarkDrawingLayer.add(animation, forKey: nil)
  }

  private func makeVibration() {
    self.triggerHapticFeedback(
      type: HapticFeedbackType.impact(
        style: UIImpactFeedbackGenerator.FeedbackStyle.heavy
      )
    )
  }
}

// MARK: Set up UI

extension ToDoCheckBoxButton {
  private func setup() {
    self.setupToggle()
    self.setupLayer()
    self.setupAnimationLayerUI()
  }

  private func setupToggle() {
    self.changesSelectionAsPrimaryAction = true
    let action = UIAction { [weak self] _ in
      guard let self, isActionBlocked else { return }
      if self.isSelected {
        self.setSelected()
      } else {
        self.setDeSelected()
      }
    }
    self.addAction(action, for: UIControl.Event.touchUpInside)
  }

  private func setupLayer() {
    self.layer.masksToBounds = true
    self.layer.borderWidth = Constant.ToDoCheckBoxButton.Layout.borderWidth
    self.layer.cornerRadius = Constant.ToDoCheckBoxButton.Layout.cornerRadius
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

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let stackView = UIStackView()
  stackView.axis = .vertical
  stackView.spacing = 50
  stackView.alignment = .center
  stackView.distribution = .fill

  let toDoButton = ToDoCheckBoxButton()
  toDoButton.updateMainColor(UIColor.toDoGardenRed)
  toDoButton.addAction(
    UIAction { _ in
      if toDoButton.isSelected {
        toDoButton.setSelected()
      } else {
        toDoButton.setDeSelected()
      }
    }, for: UIControl.Event.touchUpInside
  )
  toDoButton.widthAnchor.constraint(equalToConstant: 18).isActive = true
  toDoButton.heightAnchor.constraint(equalToConstant: 18).isActive = true

  let agreementButton = ToDoCheckBoxButton()
  agreementButton.addAction(
    UIAction { _ in
      if agreementButton.isSelected {
        agreementButton.setSelected()
      } else {
        agreementButton.setDeSelected()
      }
    }, for: UIControl.Event.touchUpInside
  )
  agreementButton.layer.cornerRadius = 7
  agreementButton.widthAnchor.constraint(equalToConstant: 14).isActive = true
  agreementButton.heightAnchor.constraint(equalToConstant: 14).isActive = true
  
  stackView.addArrangedSubview(toDoButton)
  stackView.addArrangedSubview(agreementButton)
  return stackView
}
#endif
