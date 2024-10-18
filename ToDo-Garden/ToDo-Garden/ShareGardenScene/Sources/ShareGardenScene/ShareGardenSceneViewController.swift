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
  func displayMyGarden(_ viewModel: ShareGardenScene.RequestMyGarden.ViewModel)
  func displayMyGardenRequestError()
  func displayFriendsGardenList(_ viewModel: ShareGardenScene.RequestFriendsGardenList.ViewModel)
  func displayFriendsGardenListRequestError()
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
 
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.cleanUpViewResources()
  }
}

// MARK: - Conform to display logic protocol

extension ShareGardenSceneViewController: ShareGardenSceneDisplayLogic {
  func displayMyGarden(_ viewModel: ShareGardenSceneEntity.ShareGardenScene.RequestMyGarden.ViewModel) {
    self.myGardenView.update(viewModel: viewModel)
  }
  
  func displayMyGardenRequestError() {
    self.myGardenView.showContentsLoadingFailure()
  }
  
  func displayFriendsGardenList(_ viewModel: ShareGardenScene.RequestFriendsGardenList.ViewModel) {
    self.friendsGardenView.displayFriendsGardenList(viewModel.identifiers)
  }
  
  func displayFriendsGardenListRequestError() {
    // TODO: - display friends garden request error view
  }
  
  func stopShimmeringFriendsGardenList() {
    self.friendsGardenView.stopShimmeringAnimation()
  }
}

// MARK: - Request to interactor

extension ShareGardenSceneViewController {
  private func updateViewContents() {
    self.friendsGardenView.startShimmeringAnimation()
    self.myGardenView.startShimmeringAnimation()
    self.interactor?.requestMyGarden()
    self.interactor?.requestFriendsGardenList()
  }
  
  private func cleanUpViewResources() {
    self.interactor?.cancelEntireTask()
  }
}

// MARK: - Setup

extension ShareGardenSceneViewController {
  private func setup() {
    self.setupActions()
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
  
  private func setupActions() {
    self.setupMyGardenViewRetryAction()
  }
}

// MARK: - Setup ui action

extension ShareGardenSceneViewController {
  private func setupMyGardenViewRetryAction() {
    self.myGardenView.retryAction = UIAction { _ in
      self.myGardenView.showContents()
      self.interactor?.requestMyGarden()
    }
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

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let shareGardenScene = ShareGardenSceneSceneBuilder(dependency: .preview).build()
  return shareGardenScene
}
#endif
