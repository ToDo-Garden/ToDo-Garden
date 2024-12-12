import UIKit

class StrikethroughLayer: CAShapeLayer {
  override var frame: CGRect {
    didSet {
      self.updatePath(in: self.frame)
      self.animate()
    }
  }
  
  func updatePath(in rect: CGRect) {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 0, y: rect.midY))
    path.addLine(to: CGPoint(x: rect.width, y: rect.midY))
    self.path = path.cgPath
  }
  
  func animate() {
    self.removeAnimation(forKey: "strokeEndAnimation")
    self.add(.strokeEnd, forKey: "strokeEndAnimation")
    self.strokeEnd = 1
  }
}

private extension CAAnimation {
  static var strokeEnd: CABasicAnimation {
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    animation.fromValue = 0
    animation.toValue = 1
    animation.duration = 0.3
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    return animation
  }
}

extension CAShapeLayer {
  convenience init(color: UIColor, lineWidth: CGFloat = 1) {
    self.init()
    self.strokeColor = color.cgColor
    self.lineWidth = lineWidth
  }
}
