//
//  ScrollView+Extension.swift
//  TDFoundation
//
//  Created by SONG on 1/20/25.
//

import UIKit

import TDUtility

extension UIScrollView {
  private var onEndReachedKey: String {
    return "onEndReachedKey"
  }
  
  public var onEndReached: (() -> Void)? {
    get {
      self.ao_get(key: self.onEndReachedKey) as? (() -> Void)
    }
    set {
      self.ao_setOptional(newValue, key: self.onEndReachedKey, policy: AssociationPolicy.copyNonatomic)
      self.setEndReachedDelegate()
    }
  }
  
  private func setEndReachedDelegate() {
    InfiniteScrollHandler.shared.originalDelegates[self] = self.delegate
    self.delegate = InfiniteScrollHandler.shared
  }
}

final class InfiniteScrollHandler: NSObject, UIScrollViewDelegate {
  static let shared = InfiniteScrollHandler()
  var originalDelegates: [UIScrollView: UIScrollViewDelegate?] = [:]
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard self.originalDelegates.keys.contains(scrollView) else { return }
    
    let height = scrollView.frame.size.height
    let contentYOffset = scrollView.contentOffset.y
    let distanceFromBottom = scrollView.contentSize.height - contentYOffset
    let threshold: CGFloat = 200.0
    
    if distanceFromBottom < height + threshold {
      scrollView.onEndReached?()
    }
    
    self.originalDelegates[scrollView]??.scrollViewDidScroll?(scrollView)
  }
  
  @preconcurrency
  override func responds(to aSelector: Selector!) -> Bool {
    MainActor.assumeIsolated {
      if let scrollView = self.originalDelegates.keys.first(where: { $0.delegate === self }),
        let originalDelegate = self.originalDelegates[scrollView] {
        return super.responds(to: aSelector) || originalDelegate?.responds(to: aSelector) == true
      }
      return super.responds(to: aSelector)
    }
  }
  
  @preconcurrency
  override func forwardingTarget(for aSelector: Selector!) -> Any? {
    let target: UIScrollViewDelegate? = MainActor.assumeIsolated {
      if let scrollView = self.originalDelegates.keys.first(where: { $0.delegate === self }) {
        return self.originalDelegates[scrollView] ?? nil
      }
      return nil
    }
    return target
  }
}
