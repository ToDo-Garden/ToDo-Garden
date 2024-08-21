import UIKit

struct GuideSceneContentsBuilder: Sendable {
  var bottomContents: @MainActor @Sendable (Guide.GuideState) -> [UIView]
}

extension GuideSceneContentsBuilder {
  static let live: GuideSceneContentsBuilder = {
    let bottomBuilder = GuideSceneBottomContentsViewBuilder()
    
    return GuideSceneContentsBuilder(
      bottomContents: { state in
        return bottomBuilder
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
    stack.axis = .vertical
    stack.distribution = .equalSpacing
    upSpacing.heightAnchor.constraint(equalTo: downSpacing.heightAnchor).isActive = true
    
    return stack
  }
}
