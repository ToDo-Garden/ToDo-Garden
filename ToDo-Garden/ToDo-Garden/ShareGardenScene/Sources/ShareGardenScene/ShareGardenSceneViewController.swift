//
//  ShareGardenSceneViewController.swift
//  
//
//  Created by Noah on 7/4/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import ShareGardenSceneAPI
import ShareGardenSceneEntity

@MainActor
protocol ShareGardenSceneDisplayLogic: AnyObject {
  func displayFriendsGardenList(_ viewModel: ShareGardenScene.RequestFriendsGardenList.ViewModel)
  func stopShimmeringFriendsGardenList()
}

final class ShareGardenSceneViewController: UIViewController, ShareGardenSceneViewControllable {
  
  // MARK: - VIP Properties
  
  var interactor: (ShareGardenSceneBusinessLogic & FriendsGardenStore)?
  var router: (ShareGardenSceneRoutingLogic & ShareGardenSceneDataPassing)?
  
  // MARK: - UI Properties
  
  private let myGardenView: MyGardenView
  private let friendsGardenView: FriendsGardenView
  
  // MARK: - Object lifecycle
  
  init(friendsGardenStore: FriendsGardenStore) {
    self.myGardenView = MyGardenView()
    self.friendsGardenView = FriendsGardenView(friendsGardenStore: friendsGardenStore)
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
 
  // MARK: - View life cycle

  override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    self.updateViewContents()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
  }
  
  // MARK: - View lifecycle
}

// MARK: - Conform to display logic protocol

extension ShareGardenSceneViewController: ShareGardenSceneDisplayLogic {
  func displayFriendsGardenList(_ viewModel: ShareGardenScene.RequestFriendsGardenList.ViewModel) {
    // TODO: - view update
  }
  
  func stopShimmeringFriendsGardenList() {
    // TODO: - view update
  }
}

// MARK: - Request to interactor

extension ShareGardenSceneViewController {
  private func updateViewContents() {
    self.friendsGardenView.startShimmeringAnimation()
    self.interactor?.requestFriendsGardenList()
  }
}

// MARK: - Setup

extension ShareGardenSceneViewController {
  private func setup() {
    self.setupViewAppearance()
    self.addSubviews()
    self.setupLayoutConstraints()
  }
  
  private func setupViewAppearance() {
    self.view.backgroundColor = UIColor.white
  }
  
  private func addSubviews() {
    self.view.addSubview(self.myGardenView)
    self.view.addSubview(self.friendsGardenView)
  }
  
  private func setupLayoutConstraints() {
    self.setupMyGardenViewLayoutConstraints()
    self.setupFriendsGardenViewLayoutConstraints()
  }
}

// MARK: - Layout constraints

extension ShareGardenSceneViewController {
  private func setupMyGardenViewLayoutConstraints() {
    let topInsetRatio = Constant.Layout.myGardenViewTopInsetRatio
    let topInset: CGFloat = self.view.bounds.height * topInsetRatio
    
    self.myGardenView.usingAutolayout()
    
    NSLayoutConstraint.activate([
      self.myGardenView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: topInset),
      self.myGardenView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      self.myGardenView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
    ])
  }
  
  private func setupFriendsGardenViewLayoutConstraints() {
    let topInsetRatio = Constant.Layout.friendsGardenViewTopInsetRatio
    let topInset: CGFloat = self.view.bounds.height * topInsetRatio
    
    self.friendsGardenView.usingAutolayout()
    
    NSLayoutConstraint.activate([
      self.friendsGardenView.topAnchor.constraint(equalTo: self.myGardenView.bottomAnchor, constant: topInset),
      self.friendsGardenView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      self.friendsGardenView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      self.friendsGardenView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
    ])
  }
}
