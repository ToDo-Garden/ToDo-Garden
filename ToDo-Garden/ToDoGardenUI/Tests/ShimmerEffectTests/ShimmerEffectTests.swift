//
//  ShimmerEffectTests.swift
//  ToDoGardenUI
//
//  Created by Noah on 8/10/24.
//
@testable import ToDoGardenUIComponent

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
  
  @Test
  private func startShimmeringTests() {
    let rootView = UIView()
    let subview = UIView()
    subview.isShimmering = true
    
    let subview2 = UIView()
    subview2.isShimmering = true
    
    rootView.addSubview(subview)
    rootView.addSubview(subview2)
    
    rootView.startShimmering()
    
    #expect(subview._shimmerLayer != nil)
    #expect(subview2._shimmerLayer != nil)
  }
}
