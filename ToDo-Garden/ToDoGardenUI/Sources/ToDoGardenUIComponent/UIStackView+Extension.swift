import UIKit

extension UIStackView {
  public func addSpacing(_ value: CGFloat? = nil) {
    let spacing = UIView()
    spacing.setContentCompressionResistancePriority(.required, for: axis)
    spacing.setContentHuggingPriority(.defaultLow, for: axis)
    
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
  
  // 스택뷰에 뷰를 추가하고 여백을 추가합니다.
  public func addArrangedSubViewWithSpacing(_ view: UIView, spacing: CGFloat? = nil) {
    addArrangedSubview(view)
    addSpacing(spacing)
  }
}
