//
//  ShimmerEffectTests.swift
//  ToDoGardenUI
//
//  Created by Noah on 8/10/24.
//

import Testing
import UIKit

extension Tag {
  @Tag static var shimmerEffect: Self
}

@Suite(.tags(.shimmerEffect))
@MainActor
struct ShimmerEffectTests {
  @Test
  private func isShimmeringPropertyTests() {
    let view = UIView()
    view.isShimmering = true
    #expect(view.isShimmering)
    
    view.isShimmering = false
    #expect(view.isShimmering == false)
  }
}
