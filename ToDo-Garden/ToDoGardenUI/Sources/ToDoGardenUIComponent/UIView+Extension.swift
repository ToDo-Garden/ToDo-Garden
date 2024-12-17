//
//  UIView+Extension
//
//
//  Created by Noah on 2/29/24.
//

import UIKit.UIView

extension UIView {
  public func usingAutolayout() {
    self.translatesAutoresizingMaskIntoConstraints = false
  }
  
  public func equalToParent(
    useSafeArea: Bool = false,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    guard let superview else {
      debugPrint("Error: No superview found in view hierarchy. Check \(file) at line \(line).")
      return
    }
    self.usingAutolayout()
    NSLayoutConstraint.activate([
      topAnchor.constraint(
        equalTo: useSafeArea ? superview.safeAreaLayoutGuide.topAnchor : superview.topAnchor
      ),
      leadingAnchor.constraint(
        equalTo: useSafeArea ? superview.safeAreaLayoutGuide.leadingAnchor : superview.leadingAnchor
      ),
      trailingAnchor.constraint(
        equalTo: useSafeArea ? superview.safeAreaLayoutGuide.trailingAnchor : superview.trailingAnchor
      ),
      bottomAnchor.constraint(
        equalTo: useSafeArea ? superview.safeAreaLayoutGuide.bottomAnchor : superview.bottomAnchor
      )
    ])
  }
}

extension UIView {
  func addTapGesture(_ action: @escaping () -> Void) {
    self.addGestureRecognizer(_TapGesutureRecognizer(action: action))
  }
  
  private final class _TapGesutureRecognizer: UITapGestureRecognizer {
    private var _action: () -> Void
    
    init(action: @escaping () -> Void) {
      self._action = action
      super.init(target: nil, action: nil)
      self.addTarget(self, action: #selector(self.action))
    }
    
    @objc
    private func action() {
      self._action()
    }
  }
}
