//
//  MockScrollViewDelegate.swift
//  TDFoundation
//
//  Created by SONG on 2/11/25.
//

import UIKit

final class MockScrollViewDelegate: NSObject, UIScrollViewDelegate {
  private(set) var scrollDidCallCount = 0
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.scrollDidCallCount += 1
  }
}
