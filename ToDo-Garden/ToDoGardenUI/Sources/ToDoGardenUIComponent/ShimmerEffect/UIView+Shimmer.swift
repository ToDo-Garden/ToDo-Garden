//
//  UIView+Shimmer.swift
//  ToDoGardenUI
//
//  Created by Noah on 8/9/24.
//

import UIKit

// MARK: - Properties

extension UIView {
  /// Shimmer 애니메이션이 가능한지 여부를 나타내는 변수입니다.
  public var isShimmering: Bool {
    get { self._isShimmering }
    set { self._isShimmering = newValue }
  }
  
  private var filteredShimmeringSubviews: [UIView] {
    return self.subviews.filter { $0.isShimmering }
  }
}

// MARK: - Shimmer control methods

extension UIView {
  public func startShimmering() {
    guard self.filteredShimmeringSubviews.isEmpty == false
    else { return }
    
    self.recursiveStartShimmerLayerAnimation()
  }
  
  public func stopShimmering() {
    guard self.filteredShimmeringSubviews.isEmpty == false
    else { return }
    
    self.recursiveClearShimmerLayer()
  }
}

// MARK: - Start  Shimmer animation

extension UIView {
  private func recursiveStartShimmerLayerAnimation() {
    self.filteredShimmeringSubviews.recursiveSearch {
      self.addShimmerLayer()
      self.startShimmerLayerAnimation()
    } recursiveBlock: { subview in
      subview.recursiveStartShimmerLayerAnimation()
    }
  }
  
  private func addShimmerLayer() {
    let shimmerLayer = ShimmerLayer(shimmerHolder: self)
    self._shimmerLayer = shimmerLayer
    self.layer.addSublayer(shimmerLayer.maskLayer)
  }
  
  private func startShimmerLayerAnimation() {
    guard let shimmerLayer = self._shimmerLayer
    else { return }
    
    shimmerLayer.startAnimation()
  }
}

// MARK: - Stop Shimmer animation

extension UIView {
  private func recursiveClearShimmerLayer() {
    self.filteredShimmeringSubviews.recursiveSearch {
      self.clearShimmerLayer()
    } recursiveBlock: { subview in
      subview.recursiveClearShimmerLayer()
    }
  }
  
  private func clearShimmerLayer() {
    guard var shimmerLayer = self._shimmerLayer
    else { return }
    
    shimmerLayer.clearShimmerLayer()
    self._shimmerLayer = nil
  }
}
