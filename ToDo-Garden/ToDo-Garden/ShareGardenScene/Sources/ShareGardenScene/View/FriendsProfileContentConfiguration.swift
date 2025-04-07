//
//  FriendsProfileContentConfiguration.swift
//  ShareGardenScene
//
//  Created by Noah on 9/12/24.
//

@preconcurrency import UIKit

import TDFoundation
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
    
    private(set) var state: UICellConfigurationState?
    
    func updated(for state: UIConfigurationState) -> FriendsProfileContentConfiguration {
      var mutableCopyOfSelf = self
      
      mutableCopyOfSelf.state = state as? UICellConfigurationState
      
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
    
    var configuration: UIContentConfiguration {
      didSet {
        guard let oldConfiguration = oldValue as? FriendsProfileContentConfiguration,
          let configuration = self.configuration as? FriendsProfileContentConfiguration
        else { return }
        
        if oldConfiguration != configuration {
          self.configure(for: configuration)
        }
      }
    }
    
    private static let layoutConstant = ShareGardenSceneViewController.Constant.Layout.FriendsGardenProfileInfoView.self
    
    // MARK: - UI Properties
    
    private let profileInfoView: Styled.Row = {
      let profileInfoViewConfiguration = Styled.Row.Configuration.self
      let profileInfoView = Styled.Row(
        configuration: profileInfoViewConfiguration.profile(
          profileInfoViewConfiguration.ProfileModel(
            style: profileInfoViewConfiguration.ProfileModel.Style.shareRow,
            title: "",
            description: ""
          )
        )
      )
      profileInfoView.backgroundColor = UIColor.white
      
      return profileInfoView
    }()
    
    private let containerView = UIView()
    
    var isExpanded: Bool {
      didSet {
        self.profileInfoView.isSelected = self.isExpanded
      }
    }
    
    private var task: Task<Void, any Error>?
    
    private var isEditing: Bool {
      didSet {
        if let profileInfoStackView = self.profileInfoView.subviews.first as? UIStackView {
          let defaultInset = Self.layoutConstant.defaultInset
          let editingInset = Self.layoutConstant.editingInset
          var appliedInset: NSDirectionalEdgeInsets
          
          appliedInset = self.isEditing ? editingInset : defaultInset
          profileInfoStackView.addInnerPadding(appliedInset)
        }
      }
    }
    
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
  private func configure(
    for configuration: ShareGardenSceneViewController.FriendsProfileContentConfiguration
  ) {
    guard let state = configuration.state
    else { return }
    
    self.isExpanded = state.isExpanded
    self.isEditing = state.isEditing
    self.updateProfileInfoView(using: configuration.friendsGarden)
  }
  
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
  
  private func updateProfileInfoView(using friendsGarden: ShareGardenScene.FriendsGarden) {
    let configuration = Styled.Row.Configuration.self
    self.profileInfoView.configuration = configuration.profile(
      configuration.ProfileModel.init(
        style: configuration.ProfileModel.Style.shareRow,
        title: friendsGarden.nickname,
        description: "연속 \(friendsGarden.focusStreakDays)일 집중"
      )
    )
    self.task?.cancel()
    self.task = Task {
      guard
        let urlString = friendsGarden.imageUrl,
        let url = URL(string: urlString)
      else {
        return
      }
      let image = try await Cache.shared.execute(id: url)
      self.profileInfoView.configuration.profileModel?.image = image
    }
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
