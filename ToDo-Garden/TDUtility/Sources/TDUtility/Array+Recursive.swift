//
//  Array+Recursive.swift
//  TDUtility
//
//  Created by Noah on 8/9/24.
//

import Foundation

extension Array: Recursive where Element: IterableElement {
  public func recursiveSearch(leafBlock: () -> Void, recursiveBlock: (Element) -> Void) {
    guard self.isEmpty == false
    else {
      leafBlock()
      return
    }
    
    self.forEach { recursiveBlock($0) }
  }
}
