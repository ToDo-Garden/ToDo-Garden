import CommonViews

import UIKit

struct GuideSceneContentsBuilder: Sendable {
  var baseContents: @MainActor @Sendable (Guide.GuideState) -> [BaseContent]
  var bottomContents: @MainActor @Sendable (Guide.GuideState) -> [UIView]
}

extension GuideSceneContentsBuilder {
  @MainActor
  static let live: GuideSceneContentsBuilder = {
    let baseBuilder = BaseContentsBuilder.live
    let bottomBuilder = GuideSceneBottomContentsViewBuilder()
    
    return GuideSceneContentsBuilder(
      baseContents: { state in
        switch state {
        case .todoCreate:
          return baseBuilder.todoCreate()
        case .groupManagement:
          return baseBuilder.groupManagement()
        case .todoEdit:
          return baseBuilder.todoEdit()
        case .shareTab:
          return baseBuilder.shareTab()
        }
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
