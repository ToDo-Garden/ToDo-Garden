//
//  FriendsGardenListViewCell.swift
//  ShareGardenScene
//
//  Created by Noah on 8/24/24.
//

import UIKit

import ToDoGardenUIComponent
import ToDoGardenUIResource

import ShareGardenSceneEntity

extension ShareGardenSceneViewController.FriendsGardenView {
  final class FriendsGardenListViewCell: UICollectionViewCell {
    
    // MARK: - UI Properties
    
    /// 링크의 issue가 close되면, 구현이 바뀌게 될 예정입니다.
    ///
    /// [이슈 링크](https://github.com/ToDo-Garden/ToDo-Garden/issues/439)
    private let profileInfoView: Styled.Row = {
      let profileInfoView = Styled.Row(
        configuration: Styled.Row.Configuration.profile(
          Styled.Row.Configuration.ProfileModel.gardenInfo(
            image: UIImage.defaultFriendProfileImage,
            title: "이인우",
            description: "연속 19일 집중!"
          )
        )
      )
      profileInfoView.backgroundColor = UIColor.white
      
      return profileInfoView
    }()
    
    private let gardenView: GardenView = GardenView()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      self.setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }
}

// MARK: - Setup

extension ShareGardenSceneViewController.FriendsGardenView.FriendsGardenListViewCell {
  private func setup() {
    self.setupAppearance()
    self.addSubviews()
    self.setupLayoutConstraints()
  }
  
  private func setupAppearance() {
    self.contentView.backgroundColor = UIColor.white
    self.contentView.clipsToBounds = true
  }
  
  private func addSubviews() {
    self.contentView.addSubview(self.gardenView)
    self.contentView.addSubview(self.profileInfoView)
  }
}

// MARK: - Setup default layout constraints

extension ShareGardenSceneViewController.FriendsGardenView.FriendsGardenListViewCell {
  private func setupLayoutConstraints() {
    self.setupContentViewLayoutConstraints()
    self.setupContentsContainerLayoutConstraints()
    self.setupGardenViewLayoutConstraints()
  }
  
  private func setupContentViewLayoutConstraints() {
    self.contentView.usingAutolayout()
    
    NSLayoutConstraint.activate([
      self.contentView.topAnchor.constraint(equalTo: self.topAnchor),
      self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])
  }
  
  private func setupContentsContainerLayoutConstraints() {
    self.profileInfoView.usingAutolayout()
    
    NSLayoutConstraint.activate([
      self.profileInfoView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
      self.profileInfoView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
      self.profileInfoView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
    ])
  }
  
  private func setupGardenViewLayoutConstraints() {
    self.gardenView.usingAutolayout()
    
    self.gardenView.centerXAnchor.constraint(
      equalTo: self.contentView.centerXAnchor
    ).isActive = true
  }
}
