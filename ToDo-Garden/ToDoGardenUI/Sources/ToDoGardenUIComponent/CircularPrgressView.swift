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
