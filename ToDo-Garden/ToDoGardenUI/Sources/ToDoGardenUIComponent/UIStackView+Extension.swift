import enum SwiftUICore.Edge
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
    self.addArrangedSubview(view)
    self.addSpacing(spacing)
  }
  
  public func addInnerPadding(_ value: NSDirectionalEdgeInsets) {
    self.isLayoutMarginsRelativeArrangement = true
    self.directionalLayoutMargins = value
  }
}

open class UIHStackView: UIStackView {
  final public override var axis: NSLayoutConstraint.Axis {
    get {
      return NSLayoutConstraint.Axis.horizontal
    }
    set { }
  }
  
  public init(
    alignment: Alignment = Alignment.center,
    spacing: CGFloat = 8,
    arrangedSubviews subviews: [UIView]
  ) {
    super.init(frame: CGRect.zero)
    self.alignment = alignment
    self.spacing = spacing
    subviews.forEach {
      self.addArrangedSubview($0)
    }
  }
  
  @available(*, unavailable)
  required public init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

open class UIVStackView: UIStackView {
  final public override var axis: NSLayoutConstraint.Axis {
    get {
      return NSLayoutConstraint.Axis.vertical
    }
    set { }
  }
  
  public init(
    alignment: Alignment = Alignment.center,
    spacing: CGFloat = 8,
    arrangedSubviews subviews: [UIView]
  ) {
    super.init(frame: CGRect.zero)
    self.alignment = alignment
    self.spacing = spacing
    super.axis = .vertical
    subviews.forEach {
      self.addArrangedSubview($0)
    }
  }
  
  @available(*, unavailable)
  required public init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
