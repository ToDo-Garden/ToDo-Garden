//
//  Sequence+Grouping.swift
//  TDUtility
//
//  Created by Noah on 9/2/24.
//

import Foundation

extension Sequence where Element: Identifiable {
  public func groupingByID() -> [Element.ID: [Element]] {
    return Dictionary(grouping: self, by: { $0.id })
  }
}
