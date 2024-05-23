//
//  CircularPrgressView.swift
//
//
//  Created by Noah on 5/23/24.
//

import UIKit

public final class CircularProgressView: UIView {
  
  private let progressLayer: CAShapeLayer
  private let progressBackgroundLayer: CAShapeLayer
  
  public init(progressColor: UIColor, backgroundColor: UIColor, lineWidth: CGFloat) {
    self.progressLayer = CAShapeLayer()
    self.progressBackgroundLayer = CAShapeLayer()
    super.init(frame: CGRect.zero)
    self.setupLayerAppearance(
      progressColor: progressColor,
      backgroundColor: backgroundColor,
      lineWidth: lineWidth
    )
  }
  
  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func draw(_ rect: CGRect) {
    super.draw(rect)
    self.drawCircularPath(rect)
  }
  
  public func startAnimation(duration: TimeInterval, from: Float, to value: Float) {
    self.setProgress(duration: duration, from: from, to: value)
    self.layer.addSublayer(self.progressBackgroundLayer)
    self.layer.addSublayer(self.progressLayer)
  }
}

// MARK: - Setup animation

extension CircularProgressView {
  private func drawCircularPath(_ rect: CGRect) {
    let startAngle = -(Double.pi / 2)
    let endAngle = 3 * Double.pi / 2
    let arcCenter = CGPoint(x: rect.midX, y: rect.midY)
    let radius = rect.width / 2
    
    let circularPath = UIBezierPath(
      arcCenter: arcCenter,
      radius: radius,
      startAngle: startAngle,
      endAngle: endAngle,
      clockwise: true
    )
    
    self.progressBackgroundLayer.path = circularPath.cgPath
    self.progressLayer.path = circularPath.cgPath
  }
  
  private func setProgress(duration: TimeInterval, from: Float, to value: Float) {
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    animation.duration = duration
    animation.fromValue = from
    animation.toValue = value
    self.progressLayer.strokeEnd = CGFloat(value)
    self.progressLayer.add(animation, forKey: animation.keyPath)
  }
}

// MARK: - Setup appearance

extension CircularProgressView {
  private func setupLayerAppearance(
    progressColor: UIColor,
    backgroundColor: UIColor,
    lineWidth: CGFloat
  ) {
    self.setupCircularLayerFillColor()
    self.setupCircularLayerLineWidth(to: lineWidth)
    self.setupProgressLayerStrokeColor(with: progressColor)
    self.setupProgressBackgroundLayerColor(with: backgroundColor)
  }
  
  private func setupCircularLayerFillColor() {
    self.progressLayer.fillColor = nil
    self.progressBackgroundLayer.fillColor = nil
  }
  
  private func setupCircularLayerLineWidth(to lineWidth: CGFloat) {
    self.progressLayer.lineWidth = lineWidth
    self.progressBackgroundLayer.lineWidth = lineWidth
  }
  
  private func setupProgressLayerStrokeColor(with color: UIColor) {
    self.progressLayer.strokeColor = color.cgColor
  }
  
  private func setupProgressBackgroundLayerColor(with color: UIColor) {
    self.progressBackgroundLayer.strokeColor = color.cgColor
  }
}
