//
//  TimerProgressView.swift
//
//
//  Created by Noah on 5/23/24.
//

import UIKit

import ToDoGardenUIConstant

public final class TimerProgressView: UIView {
  public var isAnimating: Bool {
    self.circularProgressView.isAnimating
  }
  private let circularProgressView: CircularProgressView
  private let dot: UIView = {
    let dotWidth = Constant.TimerProgressView.Layout.Dot.width
    let dotHeight = Constant.TimerProgressView.Layout.Dot.height
    let dot = UIView(
      frame: CGRect(x: 0, y: 0, width: dotWidth, height: dotHeight)
    )
    dot.isHidden = true
    
    return dot
  }()
  private var toValue: Double?
  
  public init(
    circularProgressView: CircularProgressView,
    dotColor: UIColor
  ) {
    self.circularProgressView = circularProgressView
    super.init(frame: CGRect.zero)
    self.setupViews(with: dotColor)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// 타이머 애니메이션을 시작하는 메소드입니다.
  /// - Parameters:
  ///   - duration: `TimerInterval` 동안 실행될지 결정하는 파라미터입니다.
  ///   - toValue: TimerProgressView`의 애니메이션이 종료되는 지점을 나타내는 값입니다.
  public func startAnimation(duration: TimeInterval, to toValue: Double) {
    self.toValue = toValue
    self.addAnimation(duration: duration, to: toValue)
    self.circularProgressView.startAnimation(duration: duration, from: Float.zero, to: Float(toValue))
  }
  
  /// TimerProgressView에 사용되는 색상들을 캡슐화한 구조체입니다.
  public struct TimerProgressViewColors {
    let progress: UIColor
    let background: UIColor
    let dot: UIColor
  }
  
  /// TimerProgressView 컴포넌트들의 색상을 설정합니다.
  /// - Parameter colors: progressLayer, backgroundLayer, dot의 색상을 포함하는 `TimerProgressViewColors` 인스턴스입니다.
  public func setColors(to colors: TimerProgressViewColors) {
    self.circularProgressView.setupProgressLayerStrokeColor(with: colors.progress)
    self.circularProgressView.setupProgressBackgroundLayerStrokeColor(with: colors.background)
    self.dot.backgroundColor = colors.dot
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
  private func addAnimation(duration: TimeInterval, to toValue: Double) {
    let circularPath = self.makeCircularPath(toValue: toValue)
    let animationKeyPath = Constant.TimerProgressView.StringLiteral.Dot.Animation.keyPath
    let animation = CAKeyframeAnimation(keyPath: animationKeyPath)
    animation.path = circularPath.cgPath
    animation.duration = duration
    animation.calculationMode = CAAnimationCalculationMode.paced
    animation.isRemovedOnCompletion = false
    animation.fillMode = CAMediaTimingFillMode.forwards
    self.dot.isHidden = false
    self.dot.layer.add(animation, forKey: nil)
  }
  
  private func makeCircularPath(toValue: Double) -> UIBezierPath {
    self.layoutIfNeeded()
    let startAngle = -(Double.pi / 2)
    let endAngle = (2 * Double.pi)
    let radius = self.bounds.width / 2
    let arcCenter = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
    
    let circularPath = UIBezierPath(
      arcCenter: arcCenter,
      radius: radius,
      startAngle: startAngle,
      endAngle: endAngle * toValue + startAngle,
      clockwise: true
    )
    
    return circularPath
  }
}


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
  timerProgressView.startAnimation(duration: 10.0, to: 0.7)
  
  return timerProgressView
}
#endif
