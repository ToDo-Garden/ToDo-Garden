//
//  ShimmerLayer.swift
//  ToDoGardenUI
//
//  Created by Noah on 8/9/24.
//

import UIKit

struct ShimmerLayer {
  let maskLayer: CAGradientLayer
  private weak var holder: UIView?
  
  init(
    shimmerHolder holder: UIView? = nil,
    backgroundColor: UIColor = ShimmerLayer.Color.gradientDarkGrey,
    highlightColor: UIColor = ShimmerLayer.Color.gradientLightGrey
  ) {
    self.maskLayer = CAGradientLayer()
    self.holder = holder
    self.setupMaskLayerColors(backgroundColor: backgroundColor, highlightColor: highlightColor)
  }

extension ShimmerLayer {
  private func setupMaskLayerColors(backgroundColor: UIColor, highlightColor: UIColor) {
    self.maskLayer.colors = [
      backgroundColor.cgColor,
      highlightColor.cgColor,
      backgroundColor.cgColor
    ]
  }
}

extension ShimmerLayer {
  struct Color {
    static let gradientDarkGrey = UIColor(red: 239 / 255.0, green: 241 / 255.0, blue: 241 / 255.0, alpha: 1)
    static let gradientLightGrey = UIColor(red: 201 / 255.0, green: 201 / 255.0, blue: 201 / 255.0, alpha: 1)
  }
}

extension ShimmerLayer {
  struct AnimationKey {
    static let shimmerAnimation = "skeletonAnimation"
  }
}
