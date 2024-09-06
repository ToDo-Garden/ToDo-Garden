import UIKit

struct GuideSceneContentsBuilder: Sendable {
  var baseContents: @MainActor @Sendable (Guide.GuideState) -> [UIView]
  var bottomContents: @MainActor @Sendable (Guide.GuideState) -> [UIView]
}

extension GuideSceneContentsBuilder {
  static let live: GuideSceneContentsBuilder = {
    let bottomBuilder = GuideSceneBottomContentsViewBuilder()
    
    return GuideSceneContentsBuilder(
      baseContents: { _ in
        let view1 = UIView()
        view1.backgroundColor = .systemIndigo
        let view2 = UIView()
        view2.backgroundColor = .purple
        let view3 = UIView()
        view3.backgroundColor = .orange
        
        return [view1, view2, view3]
      },
      bottomContents: { state in
        bottomBuilder
          .buildSubviews(state)
          .map { $0.wrapVerticallyCentered() }
      }
    )
  }()
}

// MARK: - View Utils
private extension UIView {
  func wrapVerticallyCentered() -> UIView {
    let upSpacing = UIView()
    let downSpacing = UIView()
    
    let stack = UIStackView(arrangedSubviews: [upSpacing, self, downSpacing])
    stack.axis = NSLayoutConstraint.Axis.vertical
    stack.distribution = UIStackView.Distribution.fill
    upSpacing.heightAnchor.constraint(equalTo: downSpacing.heightAnchor).isActive = true
    self.setContentHuggingPriority(
      UILayoutPriority.required,
      for: NSLayoutConstraint.Axis.vertical
    )
    
    return stack
  }
}
