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

import ShareGardenSceneEntity

extension ShareGardenSceneViewController {
  final class FriendsGardenView: UIStackView {
    
    // MARK: - UI Properties
    
    private let sectionHeaderView: SectionHeaderView = {
      let editButton = UIButton()
      let editButtonTitle = ShareGardenSceneViewController.Constant
        .StringLiteral.FriendsGardenSectionHeaderView.rightActionButtonTitle
      editButton.setTitle(editButtonTitle, for: UIControl.State.normal)
      editButton.setTitleColor(UIColor.toDoGardenEditButtonOrange, for: UIControl.State.normal)
      editButton.setTitleColor(UIColor.toDoGardenGray, for: UIControl.State.highlighted)
      editButton.titleLabel?.font = UIFont.pretendardDetailRegular12
      editButton.usingAutolayout()
      let editButtonWidth = FriendsGardenView.layoutConstant.editButtonWidth
      let editButtonHeight = FriendsGardenView.layoutConstant.editButtonHeight
      editButton.widthAnchor.constraint(equalToConstant: editButtonWidth).isActive = true
      editButton.heightAnchor.constraint(equalToConstant: editButtonHeight).isActive = true
      
      let title = ShareGardenSceneViewController.Constant
        .StringLiteral.FriendsGardenSectionHeaderView.title
      
      return SectionHeaderView(sectionTitle: title, rightActionButton: editButton)
    }()
    
    private let searchGardenButton: UIButton = {
      let searchGardenButton = UIButton()
      searchGardenButton.searchGardenButtonStyle()
      
      return searchGardenButton
    }()
    
    private let friendsGardenListView: FriendsGardenListView
    
    // MARK: - Properties
    private static let layoutConstant = ShareGardenSceneViewController.Constant.Layout.FriendsGardenView.self
    @ExecuteOnce private var setupLayoutIfNeeded: (() -> Void)?
    
    init(friendsGardenStore: FriendsGardenStore) {
      self.friendsGardenListView = FriendsGardenListView(friendsGardenStore: friendsGardenStore)
      super.init(frame: CGRect.zero)
      self.setup()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
      super.layoutSubviews()
      self.setupLayoutIfNeeded = {
        self.setupLayoutConstraints()
      }
    }
    
    func append(_ identifiers: [ShareGardenScene.FriendsGarden.ID]) {
      self.friendsGardenListView.append(identifiers)
    }
    
    func startShimmeringAnimation() {
      let numberOfPlaceholderCells = Self.layoutConstant.numberOfPlaceholderCells
      self.friendsGardenListView.startShimmeringAnimation(numberOfCells: numberOfPlaceholderCells)
    }
    
    func stopShimmeringAnimation() {
      self.friendsGardenListView.stopShimmeringAnimation()
    }
  }
}

// MARK: - Setup view appearance

extension ShareGardenSceneViewController.FriendsGardenView {
  private func setup() {
    self.setupStackView()
    self.addSubviews()
    self.setCustomSpacing()
  }
  
  private func setupStackView() {
    self.spacing = Self.layoutConstant.stackViewSpacing
    self.distribution = UIStackView.Distribution.fill
    self.axis = NSLayoutConstraint.Axis.vertical
    self.alignment = UIStackView.Alignment.center
  }
  
  private func addSubviews() {
    self.addArrangedSubview(self.sectionHeaderView)
    self.addArrangedSubview(self.searchGardenButton)
    self.addArrangedSubview(self.friendsGardenListView)
  }
}

// MARK: - Setup layout constraints

extension ShareGardenSceneViewController.FriendsGardenView {
  private func setupLayoutConstraints() {
    self.setupSectionHeaderViewLayoutConstraints()
    self.setupSearchGardenButtonLayoutConstraints()
    self.setupFriendsGadenListViewLayoutConstraints()
  }
  
  private func setupSectionHeaderViewLayoutConstraints() {
    let leftInset: CGFloat = self.bounds.width * Self.layoutConstant.sectionHeaderViewLeftInsetRatio
    let rightInset: CGFloat = self.bounds.width * Self.layoutConstant.sectionHeaderViewRightInsetRatio
    
    self.sectionHeaderView.layoutMargins = UIEdgeInsets(
      top: CGFloat.zero,
      left: leftInset,
      bottom: CGFloat.zero,
      right: rightInset
    )
    self.sectionHeaderView.isLayoutMarginsRelativeArrangement = true
    
    self.sectionHeaderView.usingAutolayout()
    
    NSLayoutConstraint.activate([
      self.sectionHeaderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.sectionHeaderView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
    ])
  }
  
  private func setupSearchGardenButtonLayoutConstraints() {
    let horizontalInset: CGFloat = self.bounds.width * Self.layoutConstant.searchGardenButtonHorizontalInsetRatio
    let height: CGFloat = Self.layoutConstant.searchGardenButtonHeight
    
    self.searchGardenButton.usingAutolayout()
    
    NSLayoutConstraint.activate([
      self.searchGardenButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: horizontalInset),
      self.searchGardenButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -horizontalInset),
      self.searchGardenButton.heightAnchor.constraint(equalToConstant: height)
    ])
  }
  
  private func setupFriendsGadenListViewLayoutConstraints() {
    self.friendsGardenListView.usingAutolayout()
    
    NSLayoutConstraint.activate([
      self.friendsGardenListView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      self.friendsGardenListView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
    ])
  }
  
  private func setCustomSpacing() {
    let searchGardenButtonTopInset = Self.layoutConstant.searchGardenButtonTopInset
    self.setCustomSpacing(searchGardenButtonTopInset, after: self.sectionHeaderView)
  }
}
