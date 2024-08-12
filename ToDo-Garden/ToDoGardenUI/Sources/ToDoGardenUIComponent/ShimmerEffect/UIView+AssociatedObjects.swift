//
//  UIView+AssociatedObjects.swift
//  ToDoGardenUI
//
//  Created by Noah on 8/9/24.
//

import UIKit

import TDUtility

extension UIView: @retroactive AssociatedObjects { }

enum ViewAssociatedKeys {
  static let isShimmering = "isShimmering"
  static let shimmerLayer = "shimmerLayer"
}

// swiftlint:disable identifier_name
extension UIView {
  var _shimmerLayer: ShimmerLayer? {
    get {
      return self.ao_get(key: ViewAssociatedKeys.shimmerLayer) as? ShimmerLayer
    } set {
      self.ao_setOptional(newValue, key: ViewAssociatedKeys.shimmerLayer)
    }
  }
  
  var _isShimmering: Bool {
    get {
      return self.ao_get(key: ViewAssociatedKeys.isShimmering) as? Bool ?? false
    } set {
      self.ao_set(newValue, key: ViewAssociatedKeys.isShimmering)
    }
  }
}
// swiftlint:enable identifier_name
