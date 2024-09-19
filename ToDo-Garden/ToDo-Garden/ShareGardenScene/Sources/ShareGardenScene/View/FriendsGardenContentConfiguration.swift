//
//  FriendsGardenGardenInfoViewContentConfiguration.swift
//  ShareGardenScene
//
//  Created by Noah on 9/13/24.
//

import UIKit

import ToDoGardenUIComponent

extension ShareGardenSceneViewController {
  final class FriendsGardenInfoView: UIView & UIContentView {
    var configuration: UIContentConfiguration
    
    private let gardenView = GardenView()
    
    override var intrinsicContentSize: CGSize {
      return CGSize(width: 375, height: 137)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    init(configuration: FriendsGardenContentConfiguration) {
      self.configuration = configuration
      super.init(frame: CGRect.zero)
      self.setup()
      self.gardenView.configure(with: configuration.pomodoroRecords)
    }
  }
}

extension ShareGardenSceneViewController.FriendsGardenInfoView {
  private func setup() {
    self.addSubviews()
    self.setupLayoutConstraints()
    self.setupAppearance()
  }
  
  private func addSubviews() {
    self.addSubview(self.gardenView)
  }
  
  private func setupLayoutConstraints() {
    self.gardenView.usingAutolayout()
    self.gardenView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    self.gardenView.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true
  }
  
  private func setupAppearance() {
    self.backgroundColor = UIColor.white
  }
}
