//
//  FriendsProfileContentConfiguration.swift
//  ShareGardenScene
//
//  Created by Noah on 9/12/24.
//

import UIKit

import ToDoGardenUIComponent

import ShareGardenSceneEntity

extension ShareGardenSceneViewController {
  struct FriendsProfileContentConfiguration: UIContentConfiguration, Identifiable {
    let id: UUID
    let friendsGarden: ShareGardenScene.FriendsGarden
    
    init(
      id: UUID,
      friendsGarden: ShareGardenScene.FriendsGarden
    ) {
      self.id = id
      self.friendsGarden = friendsGarden
    }
    
    var state: UICellConfigurationState?
    
    func updated(for state: UIConfigurationState) -> FriendsProfileContentConfiguration {
      var mutableCopyOfSelf = self
      
      if let cellState = state as? UICellConfigurationState {
        mutableCopyOfSelf.state = cellState
      }
      
      return mutableCopyOfSelf
    }
    
    func makeContentView() -> UIView & UIContentView {
      return FriendsGardenProfileInfoView(configuration: self)
    }
  }
}

extension ShareGardenSceneViewController.FriendsProfileContentConfiguration: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.id)
  }
  
  static func == (
    lhs: ShareGardenSceneViewController.FriendsProfileContentConfiguration,
    rhs: ShareGardenSceneViewController.FriendsProfileContentConfiguration
  ) -> Bool {
    return lhs.id == rhs.id && lhs.state == rhs.state
  }
}

extension ShareGardenSceneViewController {
  final class FriendsGardenProfileInfoView: UIView & UIContentView {
    
    // MARK: - UI Properties
    
    /// 링크의 issue가 close되면, 구현이 바뀌게 될 예정입니다.
    ///
    /// [이슈 링크](https://github.com/ToDo-Garden/ToDo-Garden/issues/439)
    private let profileInfoView: Styled.Row = {
      let profileInfoViewConfiguration = Styled.Row.Configuration.self
      let profileInfoView = Styled.Row(
        configuration: profileInfoViewConfiguration.profile(
          profileInfoViewConfiguration.ProfileModel(
            style: profileInfoViewConfiguration.ProfileModel.Style.shareRow,
            title: "이인우",
            description: "연속 19일 집중!"
          )
        )
      )
      profileInfoView.backgroundColor = UIColor.white
      
      return profileInfoView
    }()
    
    private let containerView = UIView()
    
    init(configuration: FriendsProfileContentConfiguration) {
      self.configuration = configuration
      self.isExpanded = false
      self.isEditing = false
      super.init(frame: CGRect.zero)
      self.setup()
      self.configure(for: configuration)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }
}

extension ShareGardenSceneViewController.FriendsGardenProfileInfoView {
  private func setup() {
    self.setupAppearance()
    self.addSubviews()
    self.setupLayoutConstraints()
  }
  
  private func setupAppearance() {
    self.backgroundColor = UIColor.white
    self.clipsToBounds = true
  }
  
  private func addSubviews() {
    self.addSubview(self.profileInfoView)
  }
}

// MARK: - Setup default layout constraints

extension ShareGardenSceneViewController.FriendsGardenProfileInfoView {
  private func setupLayoutConstraints() {
    self.setupProfileInfoViewLayoutConstraints()
  }
  
  private func setupProfileInfoViewLayoutConstraints() {
    self.profileInfoView.usingAutolayout()
    let bottomAnchor = self.profileInfoView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    bottomAnchor.priority = UILayoutPriority.defaultHigh
    
    NSLayoutConstraint.activate([
      self.profileInfoView.topAnchor.constraint(equalTo: self.topAnchor),
      self.profileInfoView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.profileInfoView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      bottomAnchor
    ])
  }
}
