//
//  ScrollView+Extension.swift
//  TDFoundation
//
//  Created by SONG on 1/20/25.
//

import UIKit

import TDUtility

extension UIScrollView {
  private var onEndReachedKey: String { "onEndReachedKey" }
  private var scrollHandlerKey: String { "scrollHandlerKey" }

  public var onEndReached: (() -> Void)? {
    get {
      self.ao_get(key: self.onEndReachedKey) as? (() -> Void)
    }
    set {
      self.ao_setOptional(newValue, key: self.onEndReachedKey, policy: AssociationPolicy.copyNonatomic)

      if newValue != nil {
        let handler = InfiniteScrollHandler(scrollView: self, originalDelegate: self.delegate)
        self.ao_set(handler, key: self.scrollHandlerKey, policy: AssociationPolicy.retainNonatomic)
        self.delegate = handler
      } else {
        self.delegate = (self.ao_get(key: self.scrollHandlerKey) as? InfiniteScrollHandler)?.originalDelegate
        self.ao_setOptional(nil, key: self.scrollHandlerKey, policy: AssociationPolicy.assign)
      }
    }
  }
  
  @MainActor private final class InfiniteScrollHandler: NSObject, UIScrollViewDelegate {
    weak var originalDelegate: UIScrollViewDelegate?
    weak var scrollView: UIScrollView?

    init(scrollView: UIScrollView, originalDelegate: UIScrollViewDelegate?) {
      self.scrollView = scrollView
      self.originalDelegate = originalDelegate
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      guard let scrollView = self.scrollView else { return }

      let height = scrollView.frame.size.height
      let contentYOffset = scrollView.contentOffset.y
      let distanceFromBottom = scrollView.contentSize.height - contentYOffset
      let threshold: CGFloat = 200.0

      if distanceFromBottom < height + threshold {
        scrollView.onEndReached?()
      }

      self.originalDelegate?.scrollViewDidScroll?(scrollView)
    }

    @preconcurrency override func responds(to aSelector: Selector!) -> Bool {
      MainActor.assumeIsolated {
        return super.responds(to: aSelector) || self.originalDelegate?.responds(to: aSelector) == true
      }
    }

    @preconcurrency override func forwardingTarget(for aSelector: Selector!) -> Any? {
      MainActor.assumeIsolated {
        return self.originalDelegate
      }
    }
  }
}
