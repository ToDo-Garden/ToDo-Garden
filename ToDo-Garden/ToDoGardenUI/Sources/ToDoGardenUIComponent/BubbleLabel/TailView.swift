//
//  TailView.swift
//
//
//  Created by SONG on 11/9/24.
//

import UIKit

import ToDoGardenUIConstant
import ToDoGardenUIResource

final class TailView: UIView {
  init() {
    super.init(frame: CGRect.zero)
    self.setupTail()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupTail() {
    let tailPath = self.createTailPath()
    let tailLayer = CAShapeLayer()
    tailLayer.path = tailPath.cgPath
    tailLayer.fillColor = UIColor.white.cgColor
    tailLayer.strokeColor = UIColor.toDoGardenGreenDark.cgColor
    tailLayer.lineWidth = 2
    self.layer.addSublayer(tailLayer)
  }
  
  private func createTailPath() -> UIBezierPath {
    let tailHeight: CGFloat = Constant.BubbleLabel.TailView.height
    let tailWidth: CGFloat = Constant.BubbleLabel.TailView.width
    let tailPath = UIBezierPath()
    
    tailPath.move(to: CGPoint(x: CGFloat.zero, y: tailHeight))
    tailPath.addLine(to: CGPoint(x: tailWidth / 2, y: CGFloat.zero))
    tailPath.addLine(to: CGPoint(x: tailWidth, y: tailHeight))
  
    return tailPath
  }
}
