import UIKit

extension UIStackView {
  public func addSpacing(_ value: CGFloat? = nil) {
    let spacing = UIView()
    spacing.usingAutolayout()
    if let value {
      switch self.axis {
      case .vertical:
        spacing.heightAnchor.constraint(equalToConstant: value).isActive = true
      case .horizontal:
        spacing.widthAnchor.constraint(equalToConstant: value).isActive = true
      @unknown default:
        break
      }
    }
    self.addArrangedSubview(spacing)
  }
}
