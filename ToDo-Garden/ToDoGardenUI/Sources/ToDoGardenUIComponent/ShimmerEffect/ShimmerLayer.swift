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
    shimmerHolder holder: UIView?,
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
  
  private func addAnimation() {
    let skeletonAnimationGroup = self.makeSlidingAnimation()
    self.maskLayer.add(
      skeletonAnimationGroup,
      forKey: ShimmerLayer.AnimationKey.shimmerAnimation
    )
  }
  
  private func makeSlidingAnimation(duration: CFTimeInterval = 2.5) -> CAAnimationGroup {
    let startPointAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.startPoint))
    startPointAnimation.fromValue = CGPoint(x: -1, y: 0.5)
    startPointAnimation.toValue = CGPoint(x: 1, y: 0.5)
    
    let endPointAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.endPoint))
    endPointAnimation.fromValue = CGPoint(x: 0, y: 0.5)
    endPointAnimation.toValue = CGPoint(x: 2, y: 0.5)
    
    let group = CAAnimationGroup()
    group.animations = [startPointAnimation, endPointAnimation]
    group.repeatCount = Float.infinity
    group.duration = duration
    group.autoreverses = false
    group.isRemovedOnCompletion = false
    group.beginTime = 0.0
    
    return group
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
