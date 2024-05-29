//
//  TimerProgressView.swift
//
//
//  Created by Noah on 5/23/24.
//

import UIKit

import ToDoGardenUIConstant

public final class TimerProgressView: UIView {
  private let circularProgressView: CircularProgressView
  private let dot: UIView
  private var toValue: Double?
  
  public init(
    circularProgressView: CircularProgressView,
    dotColor: UIColor
  ) {
    self.circularProgressView = circularProgressView
    let dotWidth = Constant.TimerProgressView.Layout.Dot.width
    let dotHeight = Constant.TimerProgressView.Layout.Dot.height
    self.dot = UIView(
      frame: CGRect(x: 0, y: 0, width: dotWidth, height: dotHeight)
    )
    super.init(frame: CGRect.zero)
    self.setupViews(with: dotColor)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func startAnimation(duration: TimeInterval, from: Double, to value: Double) {
    self.toValue = value
    self.addAnimation(duration: duration, from: from, to: value)
    self.circularProgressView.startAnimation(duration: duration, from: Float(from), to: Float(value))
  }
}

// MARK: - Setup views

extension TimerProgressView {
  private func setupViews(with dotColor: UIColor) {
    self.setupDot(with: dotColor)
    self.addSubviews()
    self.setupLayoutConstraints()
  }
}

// MARK: - Setup dot

extension TimerProgressView {
  private func setupDot(with dotColor: UIColor) {
    self.dot.layer.cornerRadius = self.dot.frame.width / 2
    self.dot.backgroundColor = dotColor
  }
}

// MARK: - Add subviews

extension TimerProgressView {
  private func addSubviews() {
    self.addSubview(self.circularProgressView)
    self.addSubview(self.dot)
  }
}

// MARK: - Setup layout constraints

extension TimerProgressView {
  private func setupLayoutConstraints() {
    self.setupCircularProgressViewLayoutConstraints()
  }
  
  private func setupCircularProgressViewLayoutConstraints() {
    self.circularProgressView.usingAutolayout()
    
    NSLayoutConstraint.activate([
      self.circularProgressView.topAnchor.constraint(equalTo: self.topAnchor),
      self.circularProgressView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.circularProgressView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      self.circularProgressView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
    ])
  }
}

// MARK: - Setup animation

extension TimerProgressView {
  private func addAnimation(duration: TimeInterval, from: Double, to value: Double) {
    let circularPath = self.makeCircularPath(fromValue: from, toValue: value)
    let animationKeyPath = Constant.TimerProgressView.StringLiteral.Dot.Animation.keyPath
    let animation = CAKeyframeAnimation(keyPath: animationKeyPath)
    animation.delegate = self
    animation.path = circularPath.cgPath
    animation.duration = duration
    animation.calculationMode = CAAnimationCalculationMode.paced
    
    self.dot.layer.add(animation, forKey: nil)
  }
  
  private func makeCircularPath(fromValue: Double, toValue: Double) -> UIBezierPath {
    self.layoutIfNeeded()
    let startAngle = -(Double.pi / 2)
    let endAngle = (2 * Double.pi)
    let radius = self.bounds.width / 2
    let arcCenter = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
    
    let circularPath = UIBezierPath(
      arcCenter: arcCenter,
      radius: radius,
      startAngle: startAngle + (2 * Double.pi) * fromValue,
      endAngle: endAngle * toValue + startAngle,
      clockwise: true
    )
    
    return circularPath
  }
}

// MARK: - Conforming to a protocol

extension TimerProgressView: CAAnimationDelegate {
  public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    guard let toValue
    else { return }
    
    let startAngle = -(Double.pi / 2)
    let dotWidth = Constant.TimerProgressView.Layout.Dot.width
    let dotHeight = Constant.TimerProgressView.Layout.Dot.height
    let dotRadius = dotWidth / 2
    let endAngle = (2 * Double.pi) * toValue + startAngle
    let adjustedAngle = atan2(sin(endAngle), cos(endAngle))
    let endOfXPosition: CGFloat = self.bounds.midX + (self.bounds.width / 2.0 * cos(adjustedAngle)) - dotRadius
    let endOfYPosition: CGFloat = self.bounds.midY + (self.bounds.width / 2.0 * sin(adjustedAngle)) - dotRadius
    self.dot.frame = CGRect(
      origin: CGPoint(x: endOfXPosition, y: endOfYPosition),
      size: CGSize(width: dotWidth, height: dotHeight)
    )
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let timerProgressView = TimerProgressView(
    circularProgressView: CircularProgressView(
      progressColor: UIColor.toDoGardenGreenDark,
      backgroundColor: UIColor.toDoGardenLeaf,
      lineWidth: 9.0
    ),
    dotColor: UIColor.toDoGardenGreenDark
  )
  timerProgressView.startAnimation(duration: 10.0, from: 0.3, to: 0.7)
  
  return timerProgressView
}
#endif
