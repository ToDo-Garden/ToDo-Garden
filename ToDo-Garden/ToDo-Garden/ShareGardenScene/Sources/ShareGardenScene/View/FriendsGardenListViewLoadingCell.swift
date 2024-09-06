//
//  FriendsGardenListViewLoadingCell.swift
//  ShareGardenScene
//
//  Created by Noah on 9/6/24.
//

import UIKit

import ToDoGardenUIComponent

extension ShareGardenSceneViewController.FriendsGardenView {
  final class FriendsGardenListViewLoadingCell: UICollectionViewCell {
    private let profilePlaceholder: UIView = {
      let profilePlaceholder = UIView()
      profilePlaceholder.usingAutolayout()
      profilePlaceholder.widthAnchor.constraint(equalToConstant: 36).isActive = true
      profilePlaceholder.heightAnchor.constraint(equalToConstant: 36).isActive = true
      profilePlaceholder.layer.cornerRadius = 18
      profilePlaceholder.isShimmering = true
      
      return profilePlaceholder
    }()
    
    private let nicknamePlaceholder: UIView = {
      let nicknamePlaceholder = UIView()
      nicknamePlaceholder.usingAutolayout()
      nicknamePlaceholder.heightAnchor.constraint(equalToConstant: 16).isActive = true
      nicknamePlaceholder.isShimmering = true
      nicknamePlaceholder.layer.cornerRadius = 8
      
      return nicknamePlaceholder
    }()
    
    private lazy var placeholderContianer: UIStackView = {
      let placeHolderContainer = UIHStackView(
        arrangedSubviews: [self.profilePlaceholder, self.nicknamePlaceholder]
      )
      placeHolderContainer.isLayoutMarginsRelativeArrangement = true
      placeHolderContainer.directionalLayoutMargins = NSDirectionalEdgeInsets(
        top: 6,
        leading: 25,
        bottom: 6,
        trailing: 25
      )
      placeHolderContainer.isShimmering = true
      
      return placeHolderContainer
    }()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      self.setup()
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
      super.prepareForReuse()
      self.stopShimmering()
    }
    
    func configure() {
      self.startShimmering()
    }
  }
}

extension ShareGardenSceneViewController.FriendsGardenView.FriendsGardenListViewLoadingCell {
  private func setup() {
    self.addSubviews()
    self.setupLayuotConstraints()
    self.setupShimmering()
  }
  
  private func addSubviews() {
    self.contentView.addSubview(self.placeholderContianer)
  }
  
  private func setupLayuotConstraints() {
    self.contentView.equalToParent()
    self.placeholderContianer.equalToParent()
  }
  
  private func setupShimmering() {
    self.contentView.isShimmering = true
  }
}
