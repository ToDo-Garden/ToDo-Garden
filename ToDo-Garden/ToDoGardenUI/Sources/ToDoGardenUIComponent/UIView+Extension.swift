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
  
  public func equalToParent() {
    if let superview {
      self.usingAutolayout()
      NSLayoutConstraint.activate([
        topAnchor.constraint(equalTo: superview.topAnchor),
        leadingAnchor.constraint(equalTo: superview.leadingAnchor),
        trailingAnchor.constraint(equalTo: superview.trailingAnchor),
        bottomAnchor.constraint(equalTo: superview.bottomAnchor)
      ])
    }
  }
}
