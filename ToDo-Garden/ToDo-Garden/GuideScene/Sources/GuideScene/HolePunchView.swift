import UIKit

class HolePunchView: UIView {
  struct TransparentFrame {
    var frame: CGRect
    var cornerRadius: CGFloat
    
    init(
      frame: CGRect,
      cornerRadius: CGFloat = 0
    ) {
      self.frame = frame
      self.cornerRadius = cornerRadius
    }
  }
  var transparentFrames: [TransparentFrame] = [] {
    didSet { self.setNeedsDisplay() }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = UIColor.black.withAlphaComponent(0.2)
  }
  
  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    self.layer.mask = self.buildMaskLayer()
  }
  
  private func buildMaskLayer() -> CALayer {
    let path = UIBezierPath(rect: self.bounds)
    path.usesEvenOddFillRule = true
    for transparentFrame in self.transparentFrames {
      let transparentPath = UIBezierPath(
        roundedRect: transparentFrame.frame,
        cornerRadius: transparentFrame.cornerRadius
      )
      path.append(transparentPath)
    }
    
    let maskLayer = CAShapeLayer()
    maskLayer.path = path.cgPath
    maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
    return maskLayer
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let view = UIView()
  view.backgroundColor = .systemIndigo
  
  let dimmingView = HolePunchView()
  dimmingView.transparentFrames = [
    .init(frame: CGRect(x: 50, y: 100, width: 100, height: 100)),
    .init(frame: CGRect(x: 200, y: 300, width: 150, height: 150), cornerRadius: 20),
    .init(frame: CGRect(x: 100, y: 500, width: 200, height: 100), cornerRadius: 15)
  ]
  view.addSubview(dimmingView)
  dimmingView.equalToParent()
  
  return view
}
#endif
