import UIKit

public class DimmingView: UIView {
  public var transparentRegions: [TransparentRegion] = [] {
    didSet { self.setNeedsDisplay() }
  }
  public struct TransparentRegion {
    public var rect: CGRect
    public var cornerRadius: CGFloat
    
    public init(rect: CGRect, cornerRadius: CGFloat) {
      self.rect = rect
      self.cornerRadius = cornerRadius
    }
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = UIColor.black.withAlphaComponent(0.2)
  }
  
  @available(*, unavailable)
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func draw(_ rect: CGRect) {
    super.draw(rect)
    self.layer.mask = self.buildMaskLayer()
  }
  
  private func buildMaskLayer() -> CALayer {
    let path = UIBezierPath(rect: self.bounds)
    path.usesEvenOddFillRule = true
    for transparentRegion in self.transparentRegions {
      let transparentPath = UIBezierPath(
        roundedRect: transparentRegion.rect,
        cornerRadius: transparentRegion.cornerRadius
      )
      path.append(transparentPath)
    }
    
    let maskLayer = CAShapeLayer()
    maskLayer.path = path.cgPath
    maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
    return maskLayer
  }
}
