//
//  SettingCollectionViewCell+addBottomRoundedBorder.swift
//
//
//  Created by Wood on 8/22/24.
//

import UIKit

extension SettingCollectionViewCell {
  /// 하단에 "U" 모양을 가진 둥근 테두리를 그리는 메서드입니다.
  func addBottomRoundedBorder(color: UIColor, width: CGFloat, cornerRadius: CGFloat) {
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
