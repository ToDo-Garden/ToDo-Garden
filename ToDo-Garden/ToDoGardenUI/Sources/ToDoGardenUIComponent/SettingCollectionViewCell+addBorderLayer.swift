//
//  SettingCollectionViewCell+addBorderLayer.swift
//
//
//  Created by Wood on 8/30/24.
//

import UIKit

extension SettingCollectionViewCell {
  /// 셀의 위치에 따라 테두리를 생성하는 함수입니다.
  func addBorderLayer(for position: Position) {
    switch position {
    case Position.top:
      self.setupBorderInTop()
    case Position.middle:
      self.setupBordersInMiddle()
    case Position.bottom:
      self.setupBordersInBottom(
        color: UIColor.toDoGardenGreenBackground,
        width: 1.0,
        cornerRadius: 10
      )
    case Position.all:
      self.setupBorder()
    }
  }
}

extension SettingCollectionViewCell {
  private func setupBorder() {
    self.layer.cornerRadius = 10
    self.layer.borderColor = UIColor.toDoGardenGreenBackground.cgColor
    self.layer.borderWidth = 1.0
  }
}

// MARK: Drawing Border Functions In Top Position

extension SettingCollectionViewCell {
  private func setupBorderInTop() {
    self.layer.maskedCorners = [
      CACornerMask.layerMinXMinYCorner,
      CACornerMask.layerMaxXMinYCorner
    ]
    self.layer.cornerRadius = 10
    self.layer.borderColor = UIColor.toDoGardenGreenBackground.cgColor
    self.layer.borderWidth = 1.0
  }
}

// MARK: Drawing Border Functions In Top Position

extension SettingCollectionViewCell {
  /// 중간에 위치한 셀의 테두리를 그리는 함수입니다.
  private func setupBordersInMiddle() {
    let layers = [
      self.addLeadingBorderLayer(),
      self.addBottomBorderLayer(),
      self.addTrailingBorderLayer()
    ]

    layers.forEach { (layer: CALayer) in
      layer.borderWidth = 1.0
      layer.borderColor = UIColor.toDoGardenGreenBackground.cgColor
      self.layer.addSublayer(layer)
    }
  }

  private func addLeadingBorderLayer() -> CALayer {
    let leadingLayer = CALayer()
    leadingLayer.frame = CGRect(
      x: self.bounds.minX,
      y: self.bounds.minY,
      width: 1.0,
      height: self.bounds.height
    )
    leadingLayer.name = SubLayerName.trailing
    return leadingLayer
  }

  private func addBottomBorderLayer() -> CALayer {
    let bottomLayer = CALayer()
    bottomLayer.frame = CGRect(
      x: self.bounds.minX,
      y: self.bounds.maxY - 1.0,
      width: self.bounds.width,
      height: 1.0
    )
    bottomLayer.name = SubLayerName.trailing
    return bottomLayer
  }

  private func addTrailingBorderLayer() -> CALayer {
    let trailingLayer = CALayer()
    trailingLayer.frame = CGRect(
      x: self.bounds.maxX - 1.0,
      y: self.bounds.minY,
      width: 1.0,
      height: self.bounds.height
    )
    trailingLayer.name = SubLayerName.trailing
    return trailingLayer
  }
}

// MARK: Drawing Border Functions In Bottom Position

extension SettingCollectionViewCell {
  /// 맨 아래에 위치한 셀의 테두리를 그리는 함수입니다.
  private func setupBordersInBottom(color: UIColor, width: CGFloat, cornerRadius: CGFloat) {
    let borderLayer = CAShapeLayer()
    borderLayer.name = SubLayerName.roundedBottom
    borderLayer.fillColor = UIColor.clear.cgColor
    borderLayer.strokeColor = color.cgColor
    borderLayer.lineWidth = width

    let path = UIBezierPath()
    self.addLeftLine(to: path, with: cornerRadius)
    self.addMinXMaxYRoundedCorner(to: path, with: cornerRadius)
    self.addBottomLine(to: path, with: cornerRadius)
    self.addMaxXMaxYRoundedCorner(to: path, with: cornerRadius)
    self.addRightLine(to: path)

    path.move(to: CGPoint(x: self.bounds.origin.x, y: self.bounds.origin.y))
    path.close()
    UIColor.toDoGardenGreenBackground.setStroke()
    borderLayer.path = path.cgPath
    self.layer.addSublayer(borderLayer)
  }

  private func addLeftLine(to borderPath: UIBezierPath, with cornerRadius: CGFloat) {
    let startPoint = CGPoint(x: self.bounds.origin.x + 0.5, y: self.bounds.origin.y)
    borderPath.move(to: startPoint)
    borderPath.addLine(to: CGPoint(x: startPoint.x, y: self.bounds.height - cornerRadius))
  }

  private func addMinXMaxYRoundedCorner(to borderPath: UIBezierPath, with cornerRadius: CGFloat) {
    let arcCenter = CGPoint(x: borderPath.currentPoint.x + cornerRadius, y: borderPath.currentPoint.y)
    borderPath.addArc(
      withCenter: arcCenter,
      radius: cornerRadius,
      startAngle: CGFloat.pi,
      endAngle: CGFloat.pi * 0.5,
      clockwise: false
    )
  }

  private func addBottomLine(to borderPath: UIBezierPath, with cornerRadius: CGFloat) {
    let endPoint = CGPoint(x: self.bounds.width - (cornerRadius + 0.5), y: borderPath.currentPoint.y)
    borderPath.addLine(to: endPoint)
  }

  private func addMaxXMaxYRoundedCorner(to borderPath: UIBezierPath, with cornerRadius: CGFloat) {
    let arcCenter = CGPoint(x: borderPath.currentPoint.x, y: borderPath.currentPoint.y - cornerRadius)
    borderPath.addArc(
      withCenter: arcCenter,
      radius: cornerRadius,
      startAngle: CGFloat.pi * 0.5,
      endAngle: 0,
      clockwise: false
    )
  }

  private func addRightLine(to borderPath: UIBezierPath) {
    let endPoint = CGPoint(x: borderPath.currentPoint.x, y: self.bounds.origin.y)
    borderPath.addLine(to: endPoint)
  }
}
