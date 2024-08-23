//
//  FriendsGardenView.swift
//  ShareGardenScene
//
//  Created by Noah on 8/20/24.
//

import UIKit

import TDUtility
import ToDoGardenUIConstant
import ToDoGardenUIResource

extension ShareGardenSceneViewController {
  final class FriendsGardenView: UIStackView {
    
    init() {
      super.init(frame: CGRect.zero)
      self.setup()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }
}

// MARK: - Setup view appearance

extension ShareGardenSceneViewController.FriendsGardenView {
  private func setup() {
    self.setupStackView()
  }
  
  private func setupStackView() {
    self.spacing = 15
    self.distribution = UIStackView.Distribution.fill
    self.axis = NSLayoutConstraint.Axis.vertical
    self.alignment = UIStackView.Alignment.center
  }
}
