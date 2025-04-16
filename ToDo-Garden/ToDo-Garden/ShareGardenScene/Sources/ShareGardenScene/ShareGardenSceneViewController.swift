//
//  ShareGardenSceneViewController.swift
//  
//
//  Created by Noah on 7/4/24.
//  Copyright (c) 2024 ToDoGarden. All rights reserved.

import UIKit

import SearchGardenSceneAPI
import ShareGardenSceneAPI
import ShareGardenSceneEntity
import ToDoGardenUIComponent

@MainActor
protocol ShareGardenSceneDisplayLogic: AnyObject {
  func displayMyGarden(_ viewModel: ShareGardenScene.RequestMyGarden.ViewModel)
  func displayMyGardenRequestError()
  func displayFriendsGardenList(_ viewModel: ShareGardenScene.RequestFriendsGardenList.ViewModel)
  func displayFriendsGardenListRequestError()
  func stopShimmeringFriendsGardenList()
}

final public class ShareGardenSceneViewController: UIViewController, ShareGardenSceneViewControllable {
  
  // MARK: - VIP Properties
  
  var interactor: (ShareGardenSceneBusinessLogic & FriendsGardenStore)?
  var router: (ShareGardenSceneRoutingLogic & ShareGardenSceneDataPassing)?
  
  // MARK: - UI Properties
  
  private let myGardenView: MyGardenView
  private let friendsGardenView: FriendsGardenView
  
  // MARK: - Object lifecycle
  
  public init(friendsGardenStore: FriendsGardenStore) {
    self.myGardenView = MyGardenView()
    self.friendsGardenView = FriendsGardenView(friendsGardenStore: friendsGardenStore)
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
 
  // MARK: - View life cycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
    self.updateViewContents()
  }
  
  public override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    self.setupViewAppearance()
  }
}

// MARK: - Conform to display logic protocol

extension ShareGardenSceneViewController: ShareGardenSceneDisplayLogic {
  func displayMyGarden(_ viewModel: ShareGardenSceneEntity.ShareGardenScene.RequestMyGarden.ViewModel) {
    self.myGardenView.update(viewModel: viewModel)
  }
  
  func displayMyGardenRequestError() {
    self.myGardenView.showRetryRequestView()
  }
  
  func displayFriendsGardenList(_ viewModel: ShareGardenScene.RequestFriendsGardenList.ViewModel) {
    self.friendsGardenView.displayFriendsGardenList(viewModel.identifiers)
  }
  
  func displayFriendsGardenListRequestError() {
    self.friendsGardenView.showRetryRequestView()
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
    self.navigationController?.isNavigationBarHidden = true
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
    self.setupFriendsGardenViewRetryAction()
    self.setupShareButtonAction()
    self.setupFriendGardenViewSearchAction()
  }
}

// MARK: - Setup ui action

extension ShareGardenSceneViewController {
  private func setupMyGardenViewRetryAction() {
    self.myGardenView.retryAction = UIAction { [weak self] _ in
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.15) {
        self?.myGardenView.showMyGardenView()
        self?.interactor?.requestMyGarden()
      }
    }
  }
  
  private func setupFriendGardenViewSearchAction() {
    self.friendsGardenView.searchButtonAction = UIAction { [weak self] _ in
      self?.router?.routeToSearchGardenScene()
    }
  }
  
  private func setupFriendsGardenViewRetryAction() {
    self.friendsGardenView.retryAction = UIAction { [weak self] _ in
      self?.friendsGardenView.showFriendsGardenListView()
      self?.interactor?.requestFriendsGardenList()
    }
  }
  
  private func setupShareButtonAction() {
    self.myGardenView.delegate = self
  }
}

extension ShareGardenSceneViewController: MyGardenViewDelegate {
  func shareButtonTapped() {
    if let profileImage = self.myGardenView.profileImage {
      self.router?.routeToInstaShareClient(icon: profileImage)
      return
    }
    
    self.router?.routeToInstaShareClient(icon: UIImage.defaultProfileImage)
  }
  
  func myGardenProfileTapped() {
    self.router?.routeToMyStatsScene()
  }
}

// MARK: - Layout constraints

extension ShareGardenSceneViewController {
  private func setupMyGardenViewLayoutConstraints() {
    let topInset = Constant.Layout.topInset
    
    self.myGardenView.usingAutolayout()
    
    NSLayoutConstraint.activate([
      self.myGardenView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: topInset),
      self.myGardenView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      self.myGardenView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
    ])
  }
  
  private func setupFriendsGardenViewLayoutConstraints() {
    self.friendsGardenView.usingAutolayout()
    
    NSLayoutConstraint.activate([
      self.friendsGardenView.topAnchor.constraint(equalTo: self.myGardenView.bottomAnchor),
      self.friendsGardenView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      self.friendsGardenView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      self.friendsGardenView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
    ])
  }
}

extension ShareGardenSceneViewController {
  public func setForGuide() {
    self.view.isShimmering = false
    let myGardenView = ShareGardenScene.RequestMyGarden.ViewModel(
      nickname: "홍길동",
      description: "형을 형이라 부르지 못한다.",
      pomodoroRecords: PomodoroRecordCollection.fixedGardenView,
      imageURL: nil
    )
    
    self.myGardenView.update(viewModel: myGardenView)
    self.friendsGardenView.displayFriendsGardenList([UUID()])
    self.myGardenView.stopShimmeringAnimation()
  }
  
  public func getMyProfileView() -> UIView {
    return self.myGardenView.getMyProfileViewView()
  }
  
  public func getShareButton() -> UIView {
    return self.myGardenView.getShareButton()
  }
}

#if DEBUG
@available(iOS 17.0, *)
#Preview {
  let shareGardenScene = ShareGardenSceneBuilder(dependency: .preview ).build()
  return shareGardenScene
}
#endif
