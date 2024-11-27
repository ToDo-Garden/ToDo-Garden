//
//  RootTabBar.swift
//  RootTabBar
//
//  Created by Noah on 11/27/24.
//

import UIKit

extension RootTabBarController {
  final class RootTabBar: UITabBar {
    private let topSeparatorLineLayer: CALayer = {
      let topSeparatorLineLayer = CALayer()
      topSeparatorLineLayer.backgroundColor = UIColor.toDoGardenGreenBackground.cgColor
      return topSeparatorLineLayer
    }()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      self.setupTabBarAppearance()
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
      super.layoutSubviews()
      self.topSeparatorLineLayer.frame.size = CGSize(width: self.bounds.width, height: 1)
      self.adjustTabBarItemImageInsets()
    }
    
    private func adjustTabBarItemImageInsets() {
      self.items?.forEach { item in
        item.imageInsets = LayoutConstant.imageInsets
      }
    }
    
    private func setupTabBarAppearance() {
      self.tintColor = UIColor.toDoGardenGreenDark
      self.backgroundColor = UIColor.white
      self.layer.addSublayer(self.topSeparatorLineLayer)
    }
  }
}

extension RootTabBarController.RootTabBar {
  typealias LayoutConstant = Constant.Layout.RootTabBar
}
